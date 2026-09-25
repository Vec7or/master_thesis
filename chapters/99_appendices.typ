#import "../glossary/glossary.typ": glossary-entry-list
#import "../dependencies/glossarium-0.5.10/glossarium.typ": gls, glspl, print-glossary

// = Usage rights
// The same usage rights as for the first project work apply (see below).
// #figure(
//   image("../assets/Usage_Rights.svg", width: 96%),
//   caption: "Usage rights for the first project work",
// )

= Protocols
== Meeting Protocols

=== Meeting 20.02.2026
#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: horizon,
  table.header([*Date*], [*Time*], [*Duration*]),
  "20.02.2026", "15:00", "1h",
)

==== Attendees
- Carlo Kirchmeier
- Prof. Dr. Daniel P. Politze
==== Agenda Items
- Feedback on previous project work
- Start of Project
- Discussion of initial project plan
==== Decisions
-
==== Questions
- What is the timeline of the project, and when are the deadlines?
  - 21.06.2026 for the final report would be a good target, but we can also adjust this if necessary
- How often should we meet for project updates?
  - We can meet every 2 weeks for project updates, but we can also adjust this if necessary
  - Calendar series for every 2 weeks starting from 20.02.2026 at 15:00 will be created
==== Open Issues
#table(
  columns: (auto, auto),
  inset: 10pt,
  align: horizon,
  table.header([*Issue*], [*Responsible*]),
  "Carlo Kirchmeier", "Create a poll for a mid project presentation meeting end of April or beginning of May",
  "Carlo Kirchmeier", "Set up a recurring series for regular meetings every 2 weeks on Friday at 15:00",
  "Carlo Kirchmeier", "Revise task and project plan based on the discussion and feedback",
)
==== Next Meeting
#table(
  columns: (auto, auto),
  inset: 10pt,
  align: horizon,
  table.header([*Date*], [*Time*]),
  "06.03.2026", "15:00",
)

= Glossary
#print-glossary(glossary-entry-list)

= Bibliography
#bibliography("../bibliography/bibliography.yml", title: none)
