"""The ladder in frontier.py, pinned. Run: python -m unittest discover -s .claude/skills/wave"""
import unittest

from frontier import classify, parse_reference


def issue(number, **overrides):
    base = {"number": number, "title": f"Issue {number}", "state": "open", "type": "Task",
            "stage": "Triaged", "assignees": [], "parent": None, "blocked_by": [], "open_prs": [],
            "children": []}
    base.update(overrides)
    return base


def run(roots, *issues):
    payload = {"roots": [{"argument": str(r), "number": r} for r in roots],
               "issues": {str(i["number"]): i for i in issues}}
    return classify(payload)


def bucket_of(result, number):
    for name, entries in result["buckets"].items():
        for entry in entries:
            if entry["number"] == number:
                return name, entry
    return None, None


class Ladder(unittest.TestCase):
    def assert_routes(self, leaf, bucket, skill=None):
        result = run([1], issue(1, type="Epic", children=[leaf["number"]]), leaf)
        name, entry = bucket_of(result, leaf["number"])
        self.assertEqual(name, bucket)
        if skill:
            self.assertEqual(entry["action"]["skill"], skill)

    def test_closed_is_done(self):
        self.assert_routes(issue(2, state="closed"), "done")

    def test_assigned_is_in_flight(self):
        self.assert_routes(issue(2, assignees=["someone"]), "in_flight")

    def test_open_pull_request_is_in_flight(self):
        self.assert_routes(issue(2, open_prs=[50]), "in_flight")

    def test_needs_information_needs_a_person(self):
        self.assert_routes(issue(2, stage="Needs Information"), "human")

    def test_wayfinder_needs_a_person(self):
        self.assert_routes(issue(2, type="Wayfinder", stage="Triaged"), "human")

    def test_open_blocker_is_blocked(self):
        self.assert_routes(issue(2, blocked_by=[9]), "blocked")

    def test_blocked_stage_is_blocked_and_held(self):
        result = run([1], issue(1, type="Epic", children=[2]), issue(2, stage="Blocked"))
        name, entry = bucket_of(result, 2)
        self.assertEqual(name, "blocked")
        self.assertTrue(entry["held"])

    def test_new_and_unstaged_go_to_triage(self):
        self.assert_routes(issue(2, stage="New", type="Bug"), "frontier", "triage")
        self.assert_routes(issue(2, stage=None, type=None), "frontier", "triage")

    def test_triaged_feature_goes_to_grilling(self):
        self.assert_routes(issue(2, type="Feature", stage="Awaiting Review"), "frontier", "grill-to-spec")

    def test_stub_goes_to_grilling_at_any_stage(self):
        self.assert_routes(issue(2, type="Stub", stage="Awaiting Review"), "frontier", "grill-to-spec")

    def test_spec_goes_to_breakdown(self):
        self.assert_routes(issue(2, type="Spec", stage="Awaiting Review"), "frontier", "to-tickets")

    def test_childless_epic_goes_to_breakdown(self):
        self.assert_routes(issue(2, type="Epic", stage="Triaged"), "frontier", "to-tickets")

    def test_research_goes_to_research(self):
        self.assert_routes(issue(2, type="Research"), "frontier", "research")

    def test_triaged_task_and_bug_go_to_deliver(self):
        self.assert_routes(issue(2, type="Task"), "frontier", "deliver")
        self.assert_routes(issue(2, type="Bug"), "frontier", "deliver")

    def test_anything_else_needs_a_person(self):
        self.assert_routes(issue(2, type="Spec", stage="Triaged"), "human")


class Walk(unittest.TestCase):
    def test_deliver_under_a_parent_names_it(self):
        result = run([1], issue(1, type="Epic", children=[2]), issue(2))
        _, entry = bucket_of(result, 2)
        self.assertEqual(entry["action"]["argument"], "1/2")

    def test_deliver_with_no_parent_is_bare(self):
        _, entry = bucket_of(run([2], issue(2)), 2)
        self.assertEqual(entry["action"]["argument"], "2")

    def test_initiative_walks_through_epics(self):
        result = run([1], issue(1, type="Initiative", children=[2]),
                     issue(2, type="Epic", children=[3]), issue(3))
        name, entry = bucket_of(result, 3)
        self.assertEqual((name, entry["parent"], entry["root"]), ("frontier", 2, 1))
        self.assertIn(1, result["parents"])
        self.assertIn(2, result["parents"])

    def test_blocked_epic_holds_its_children_unwalked(self):
        result = run([1], issue(1, type="Initiative", children=[2]),
                     issue(2, type="Epic", stage="Blocked", children=[3]), issue(3))
        self.assertEqual(bucket_of(result, 2)[0], "blocked")
        self.assertIsNone(bucket_of(result, 3)[0])

    def test_two_roots_reaching_one_ticket_dispatch_it_once(self):
        result = run([1, 4], issue(1, type="Epic", children=[2]), issue(2),
                     issue(4, type="Epic", children=[2]))
        self.assertEqual(result["counts"]["frontier"], 1)

    def test_a_cycle_terminates_with_a_warning(self):
        result = run([1], issue(1, type="Epic", children=[2]), issue(2, type="Epic", children=[1]))
        self.assertTrue(result["warnings"])

    def test_all_done_parent_is_reported(self):
        result = run([1], issue(1, type="Epic", children=[2]), issue(2, state="closed"))
        self.assertTrue(result["parents"][1]["all_done"])

    def test_unreadable_child_is_a_warning(self):
        result = run([1], issue(1, type="Epic", children=[2]))
        self.assertTrue(result["warnings"])


class Arguments(unittest.TestCase):
    def test_references(self):
        self.assertEqual(parse_reference("25"), 25)
        self.assertEqual(parse_reference("#25"), 25)
        self.assertEqual(parse_reference("https://github.com/photonle/Photon/issues/25"), 25)
        self.assertIsNone(parse_reference("https://github.com/photonle/Photon-v2/issues/25"))
        self.assertIsNone(parse_reference("--inline"))

    def test_closed_and_unreadable_arguments_are_skipped(self):
        payload = {"roots": [{"argument": "1", "number": 1}, {"argument": "2", "number": 2},
                             {"argument": "x", "number": None}],
                   "issues": {"1": issue(1, state="closed")}}
        statuses = [a["status"] for a in classify(payload)["arguments"]]
        self.assertEqual(statuses, ["skipped", "skipped", "skipped"])


if __name__ == "__main__":
    unittest.main()
