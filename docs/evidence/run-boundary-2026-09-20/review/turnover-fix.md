# Remaining P1: event turnover

Follow-up finding valid: event cleanup failure previously recorded only on retained entry could disappear when DispatchMap closed-and-cleared an already-closed failed entry. BeginActOpening was another assignment site, so it is guarded too.

Minimal shared fix:
- Extracted existing DispatchMap close-and-clear into ClearEventEntry without changing behavior, added fixture: EventEntry.Fail swallows throwing cleanup, call real ClearEventEntry turnover, then BeginRunEpoch. This goes RED on the intended assertion ('map turnover cannot discard a previously failed event cleanup before the next run boundary'), not a missing symbol. Evidence event-turnover-red/{native-build.log,native-check.log,commands.jsonl}.
- ClearEventEntry now throws event_cleanup_failed before dropping an entry with historical CleanupFailed. If first Close itself throws, assignment also never runs. It retains the failed entry for later retirement.
- BeginRunEpoch reuses ClearEventEntry as its Retire(Action) callback, so either current or historical error is latched by Release and cannot escape the new native postfix. This removes the duplicate event-close/check code.
- BeginActOpening returns null if the retained entry has CleanupFailed, preserving it without throwing into the observation hook. It cannot overwrite failed history with a new opening.
- Tests check real shared-helper behavior, repeated boundaries, exact-once cleanup, a successful turnover control, and compiled binding of DispatchMap/BeginRunEpoch/BeginActOpening guards.

Source frozen for second focused follow-up; current complete patch is parent/final.diff. Final restored-source gates are in parent/final-v2/. Prior accepted cleanup/publisher tests remain. No install/gameplay/provider changes. Please verify remaining original P1#2 plus any defect introduced specifically by this fix; original #1/#3 dispositions and selector/new-run findings otherwise unchanged.
