<?php

include __DIR__ . '/vendor/autoload.php';
use GmodStore\GMad\{AddonWriter, AddonMeta};

$photon = realpath(__DIR__ . '/../../');
$pl = strlen($photon) + 1;
$folders = ['lua', 'materials', 'models', 'sound'];

$files = [];
foreach ($folders as $folder){
	$path = "{$photon}/{$folder}/";
	$dirFiles = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path), RecursiveIteratorIterator::SELF_FIRST);

	foreach ($dirFiles as $file){
		if ($file->getFilename() == '.' || $file->getFilename() == '..'){continue;}
		if ($file->isDir()){continue;}

		$relative = substr($file->getPathname(), $pl);
		$relative = str_replace('\\', '/', $relative);
		$files[$relative] = $file->openFile('rb');
	}
}

$meta = new AddonMeta();
$meta->setSteamID(76561198033238057);
$meta->setTimestamp((new DateTime())->getTimestamp());
$meta->setName('Photon Lighting Engine');
$meta->setDescription('ze best lighting engine in all ze vurld');
$meta->setAuthor('The Photon Team.');
$meta->setVersion(1);

$stream = fopen(__DIR__ . '/photonle.gma', 'wb+');
$writer = new AddonWriter($stream);
$writer->setAddonMeta($meta);
$writer->setFiles(function() use ($files){
	foreach ($files as $path => $file){
		yield $path => $file->fread($file->getSize());
	}
});
$writer->write();
fclose($stream);

// $reader = new AddonReader(fopen)