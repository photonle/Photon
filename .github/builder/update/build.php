#!/usr/bin/env php
<?php

use Symfony\Component\Yaml\Yaml;

require __DIR__ . '/vendor/autoload.php';

$types = json_decode(file_get_contents(__DIR__ . '/types.json'), true);
$categories = json_decode(file_get_contents(__DIR__ . '/categories.json'), true);
$release = json_decode($_SERVER['RELEASE_CONTEXT'], true);

$body = $release['body'];
$title = $release['name'];
$date = $release['published_at'];
$tag = $release['tag_name'];
if (stripos($tag, 'v') === 0){
	$tag = substr($tag, 1);
}

$lines = explode("\n", $body);
$lines = array_map('trim', $lines);
$lines = array_filter($lines);

$titleMatch = '';
$subTitleMatch = '';
$itemMatch = '-';

$header = $lines[0];
if (stripos($header, '**') === 0){
	// We start with a **.
	$titleMatch = '**';
} elseif (stripos($header, '*') === 0){
	$titleMatch = '*';
}
if ($titleMatch === ''){
	$titleMatch = false;
	echo "Assuming single-category operation.";
} elseif ($titleMatch === '**'){
	$subTitleMatch = '*';
}
$titleMatchLen = $titleMatch ? strlen($titleMatch) : 0;
$itemMatchLen = strlen($itemMatch);

function strcontains(string $haystack, string $needle): bool {
	return stripos($haystack, $needle) !== false;
}

function resolveLine($line){
	global $types;

	$powers = $types['powers'];

	$calc = [];
	$classes = $line['class'];

	$category = $classes['category'];
	if (isset($types['category'][$category])){
		$type = $types['category'][$category];
		$calc[$type] = ($calc[$type] ?? 0) + $powers['category'];
	}

	if (isset($classes['tag'], $types['class'][$classes['tag']])){
		$class = $types['class'][$classes['tag']];
		foreach ($class as $type){
			$calc[$type] = ($calc[$type] ?? 0) + $powers['class'];
		}
	}
	
	foreach ($classes['words'] as $type){
		$calc[$type] = ($calc[$type] ?? 0) + $powers['word'];
	}

	if (empty($calc)){
		$line['class'] = $types['default'];
		echo "'{$line['text']}' failed automatic resolution, fell back to default {$line['class']}\n";
	} else {
		$keys = array_keys($calc, max($calc));
		if (count($keys) === 1){
			$line['class'] = $keys[0];
		} else {
			$keys = array_flip($keys);
			$keys = array_intersect_key($types['fallback'], $keys);
			$key = min($keys);
			$keys = array_flip($keys);
			$line['class'] = $keys[$key];
			echo "'{$line['text']}' failed automatic resolution, fallback sorting chose {$line['class']}\n";
		}
	}
	$line['change'] = $line['text'];
	unset($line['text']);
	$line['type'] = $line['class'];
	unset($line['class']);

	return $line;
}

$output = [];
$category = 'fixes';
foreach ($lines as $line){
	if ($titleMatch && stripos($line, $titleMatch) === 0){
		$line = substr($line, $titleMatchLen, -$titleMatchLen);
		if (substr($line, -1) === ':'){$line = substr($line, 0, -1);}
		$line = trim($line);
		$category = $categories[$line] ?? $line;
		$output[$category] = $output[$category] ?? [];
		echo "Set new Category: {$category}\n";
	} elseif (stripos($line, $itemMatch) === 0){
		$line = substr($line, $itemMatchLen);
		$line = trim($line);

		$class = [];
		if (stripos($line, '[') === 0){
			$end = stripos($line, ']');
			if ($end !== false){
				$class['tag'] = substr($line, 1, $end - 1);
				$line = substr($line, $end + 1);
				$line = trim($line);
			}
		}
		$class['category'] = $category;
		$class['words'] = [];

		foreach ($types['words'] as $word => $type){
			if (strcontains($line, $word)){
				$class['words'][] = $type;
			}
		}

		$output[$category][] = ['class' => $class, 'text' => $line];
	} /** @noinspection PhpStatementHasEmptyBodyInspection */ elseif ($subTitleMatch !== '' && stripos($line, $subTitleMatch) === 0){
		// Ignore Subtitles.
	} else {
		echo "\tUnknown Line Type! {$line}\n";
	}
}

foreach ($output as &$category){
	foreach ($category as &$change){
		$change = resolveLine($change);
	}
}

$yml = [];
if ($title && $title !== ''){$yml['name'] = $title;}
$yml['date'] = DateTime::createFromFormat(DateTime::RFC3339, $date)->format('Y-m-d H:i');
if (!empty($output)){$yml['changes'] = $output;}

$yml = Yaml::dump($yml, 2, 2, Yaml::DUMP_OBJECT_AS_MAP);
$yml = trim($yml);
$html = <<<EOF
---
{$yml}
---
EOF;

file_put_contents(__DIR__ . '/' . $tag . '.html', $html);
