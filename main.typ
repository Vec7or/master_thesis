#import "dependencies/arkheion-0.1.2/template.typ": arkheion, arkheion-appendices
#import "dependencies/glossarium-0.5.10/glossarium.typ": gls, glspl, make-glossary, print-glossary, register-glossary
#import "glossary/glossary.typ": glossary-entry-list

/* ============================== CHAPTER CODE ============================== */
// author: tinger

#let chapter = figure.with(
  kind: "chapter",
  // same as heading
  numbering: none,
  // this cannot use auto to translate this automatically as headings can, auto also means something different for figures
  supplement: "Chapter",
  // empty caption required to be included in outline
  caption: [],
)

// emulate element function by creating show rule
#show figure.where(kind: "chapter"): it => {
  pagebreak()
  set align(horizon)
  set text(30pt)
  counter(heading).update(0)
  strong("Chapter") + [ ] + if it.numbering != none { strong(it.counter.display(it.numbering)) } + linebreak()
  strong(it.body)
  pagebreak(weak: true)
}

// no access to element in outline(indent: it => ...), so we must do indentation in here instead of outline
#show outline.entry: it => {
  if it.element.func() == figure {
    // we're configuring chapter printing here, effectively recreating the default show impl with slight tweaks
    let res = link(
      it.element.location(),
      // we must recreate part of the show rule from above once again
      if it.element.numbering != none {
        numbering(it.element.numbering, ..it.element.counter.at(it.element.location()))
      }
        + [ ]
        + it.element.body,
    )

    if it.fill != none {
      res += [ ] + box(width: 1fr, it.fill) + [ ]
    } else {
      res += h(1fr)
    }
    show link: set text(fill: black)
    res += link(it.element.location(), it.page())
    strong(res) + linebreak()
  } else {
    h(1em * (it.level - 1)) + it.prefix() + str("  ") + it.inner() + linebreak()
    //it.indented(it.prefix(), it.body())
  }
}

// new target selector for default outline
#let chapters-and-headings = figure.where(kind: "chapter", outlined: true).or(heading.where(outlined: true))

//
// start of actual doc prelude
//
#set heading(numbering: "1.")
// can't use set, so we reassign with default args
#let chapter = chapter.with(numbering: "I")
/* ============================== CHAPTER CODE ============================== */

#set page(
  "a4",
  background: [
    #place(
      top + right,
      float: true,
      scope: "parent",
      dx: -2em,
      dy: 2em,
    )[
      // #block(
      //   text(red, size: 30pt)[
      //     !!!! DEV BUILD !!!!
      //   ],
      // )
    ]
  ],
)


#show: make-glossary
#register-glossary(glossary-entry-list)
#show link: set text(fill: rgb(153, 0, 153))

#show: arkheion.with(
  title: "Crypto-Agile Secure Boot: Integrating Post-Quantum Signatures into MCUboot",
  authors: (
    (
      name: "Carlo Kirchmeier",
      email: "carlo.kirchmeier@ost.ch",
      affiliation: "Eastern Switzerland University of Applied Sciences",
    ),
  ),
  abstract: [#include "chapters/00_abstract.typ"],
  keywords: ("Embedded", "MCUboot", "Post-Quantum", "Crypto-Agile", "Security"),
  date: datetime.today().display("[day]. [month repr:long] [year]"),
)


#show ref: it => {
  let el = it.element
  // Skip all other references.
  if el == none {
    return it
  }

  if it.citation.supplement == none {
    return it
  }

  if it.citation.supplement.text.starts-with("s-") != true {
    return it
  }

  return link(el.location(), it.citation.supplement.text.trim("s-", at: start, repeat: false))
}

#set heading(numbering: none, outlined: false)
#set heading(numbering: "1.", outlined: true)

#pagebreak()

#outline(target: chapters-and-headings)

#pagebreak()

#include "chapters/01_management_summary.typ"
#chapter[Project Plan]
#include "chapters/02_project_plan.typ"
#chapter[Prestudy] <prestudy>
#include "chapters/03_prestudy.typ"
#chapter[Architecture] <architecture>
#include "chapters/04_architecture.typ"
#chapter[Construction]
#include "chapters/05_construction.typ"
#chapter[Requirements Verification]
#include "chapters/06_requirements_verification.typ"
#chapter[Conclusion]
#include "chapters/07_conclusion.typ"

#chapter[Appendix]
#arkheion-appendices()[#include "chapters/99_appendices.typ"]
