#let entry(
  when: "",
  what: "",
  details: (),
) = [
  #let d = (([*#what*]), details, ("")).flatten()
  #grid(
    columns: (1.5fr, 8fr),
    gutter: 20pt,
    rows: (auto),
      grid.cell(align: right, [*#when*]), grid.cell(align: left, (d.join([ \ ]))
    )
  )
]

#let papers(
  papers : ()
) = {
  for(paper) in papers {
    cite(
      label(paper.label),
      form: "full",
    )
    if(paper.keys().contains("score")) {
      linebreak()
      paper.score
    } else {
      []
    }
    linebreak()
    v(15pt, weak: true)
  }
}

#let custom-render = (index, entry, extra, details) => {
  [
    "[" + (index + 1) + "] ",
    #entry.author(),
    ", ",
    #strong(extra + entry.title()),
    #if entry.journal() {[
      ", ",
      #entry.journal()
    ]},
    ", ",
    #entry.year(),
    ", ",
    #if entry.doi() {[
      doi: , #entry.doi()
    ]}
  ]
}



/// Custom render for the entries
/// `show-type` should be "box", "filled" or "underline"
/// `label-color` is the color of the label
/// `default-color` is the color of the text
/// `body` is the body of document
#let show_link(
  show-type,
  label-color,
  default-color,
  body
) = {
  show link: this => {
    if show-type == "box" {
      if type(this.dest) == label {
        // Make the box bound the entire text:
        set text(bottom-edge: "bounds", top-edge: "bounds")
        box(this, stroke: label-color + 1pt)
      } else {
        set text(bottom-edge: "bounds", top-edge: "bounds")
        box(this, stroke: default-color + 1pt)
      }
    } else if show-type == "filled" {
      if type(this.dest) == label {
        text(this, fill: label-color)
      } else {
        text(this, fill: default-color)
      }
    } else if show-type == "underline" {
      if type(this.dest) == label {
          let this = text(this, fill: label-color)
          underline(this, stroke: label-color)
      } else {
          let this = text(this, fill: default-color)
          underline(this, stroke: default-color)
      }
    }
    else {
      this
    }
  }
  body
}

/// Set the global settings for the document
/// `textfont` is the font of the text
/// `body` is the body of the document
#let set_global_settings(textfont, body) = {
  set text(
    size: 11pt,
    hyphenate: false,
    font: textfont,
    // font: "Iosevka NF",
    // font: "Noto Sans Serif",
    // font: "Cantarell",
    // font: "Noto Sans Linear B",
  )
  set page(
    paper: "us-letter",
    numbering: "1",
    number-align: center,
  )
  set par(justify: true)

  show "ADAPT Lab": name => box[
    #link("https://di.unimi.it/it/ricerca/risorse-e-luoghi-della-ricerca/laboratori-di-ricerca/adapt-lab")[#name]
    #box(image(
      "logo-lab.svg",
      height: 1em,
    ))
  ]

  show "ALaDDIn Lab": name => box[
    #link("https://aladdin.unimi.it/")[#name]
  ]

  show "LIM Lab": name => box[
    #link("https://www.lim.di.unimi.it/")[#name]
  ]

  show "Università degli Studi di Milano": name => box[
    // #name
    #link("https://www.unimi.it/it")[#name]
    // #box(image(
    //   "minerva-new.svg",
    //   height: 0.7em,
    // ))
  ]

  show "Neverlang": name => box[
    #link("https://www.sciencedirect.com/science/article/pii/S1477842415000056")[#name]
  ]

  show "IEEE 1599": name => box[
    #link("https://ieee1599.lim.di.unimi.it/")[#name]
  ]

  show "Bebras Challenge": name => box[
    #link("https://bebras.it/")[#name]
  ]

  body
}

/// Show the title of the document
/// `heading-align` is the alignment of the heading
/// `heading-underline` is a boolean to underline the heading
/// `textfill` is the color of the text
/// `name` is the name of the document
#let show_title(heading-align, heading-underline, textfill, name) = {
  set align(heading-align)
  text(34pt, fill: textfill, smallcaps(name))

  if heading-underline {
    v(10pt, weak: true)
    line(stroke: 1.5pt + textfill, length: 100%)
  }
  v(10pt, weak: true)
}

/// Show the subtitle of the document
/// `sub-heading-align` is the alignment of the sub-heading
/// `textfill` is the color of the text
/// `subtitle` is the subtitle of the document
#let show_subtitle(sub-heading-align, textfill, subtitle) = {
  set align(sub-heading-align)
  text(22pt, fill: textfill, subtitle)
}

/// Show the information of the document
/// `textfill` is the color of the text
/// `personal_info` is the personal information
/// `contact_info` is the contact information
#let show_information(textfill, personal_info, contact_info) = {
  show heading.where(level : 2): it => {
      set text(14pt, fill: textfill)
      block(smallcaps(it.body))
      v(15pt, weak: true)
  }
  grid(
    columns: (1fr, 1fr),
    align(left)[
      == Personal Information
      Born in #personal_info.birth_place on #personal_info.date_of_birth \
      Resident of #personal_info.residence \
      #for (i, email) in personal_info.emails.enumerate(start: 1) [
          E-mail #i: #link(email) \
      ]
      Phone: #personal_info.phone
    ],
    align(right)[
      == Contact Information
      Github: #link(contact_info.github_link)[#contact_info.github_name] \
      Telegram: #link(contact_info.telegram_link)[#contact_info.telegram_name] \
      LinkedIn: #link(contact_info.linkedin_link)[#contact_info.linkedin_name] \
      Twitter: #link(contact_info.twitter_link)[#contact_info.twitter_name] \
    ]
  )
}

/// Set the settings for the heading
/// `heading_level-1-align` is the alignment of the first level heading
/// `heading_level-2-align` is the alignment of the second level heading
/// `heading-underline` is a boolean to underline the heading
/// `textfill` is the color of the text
#let set_heading_settings(heading_level-1-align, heading_level-2-align, heading-underline, textfill, body) = {
  show heading.where(level: 1): it => {
    set align(heading_level-1-align)
    set text(20pt, fill: textfill, weight: "regular")
    smallcaps(it.body)
    if heading-underline {
      v(5pt, weak: true)
      line(stroke: 1pt + textfill, length: 100%)
    }
  }

  show heading.where(level : 2): it => {
    set align(heading_level-2-align)
    set text(14pt, fill: textfill)
    block(smallcaps(it.body))
    v(15pt, weak: true)
  }

  body
}

#let cv(
  name: "",
  subtitle: "Curriculum Vitae",
  personal_info: (),
  contact_info: (),
  heading-align: center,
  sub-heading-align: center,
  heading_level-1-align: right,
  heading_level-2-align: left,
  heading-underline: true,
  textfont: "Linux Libertine",
  textfill: gradient.linear(..color.map.crest.slice(130,), relative:"parent"),
  linkfill: gradient.linear(..color.map.crest.slice(130,), relative:"parent"),
  // textfill: gradient.linear(..(color.map.mako.slice(50,100).rev(), color.map.mako.slice(50,100)).flatten(), relative:"parent"),
  bib: (),
  body,
) = {
  show: body => set_global_settings(textfont, body)
  show: body => show_link("filled", green, linkfill, body)

  show_title(heading-align, heading-underline, textfill, name)
  show_subtitle(sub-heading-align, textfill, subtitle)
  show_information(textfill, personal_info, contact_info)

  show: body => set_heading_settings(heading_level-1-align, heading_level-2-align, heading-underline, textfill, body)

  show bibliography: none
  bibliography(bib)

  columns(1, body)
}
