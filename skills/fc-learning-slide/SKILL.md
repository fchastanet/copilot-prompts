---
name: "fc-learning-slide"
description: |
  Learn how to create engaging learning slides that effectively communicate your message
  and keep your audience engaged."
---

# Introduction

As a learning designer, you will create slides that not only convey information but also
engage your audience. In this skill, we will explore how to design effective learning slides
that capture attention and facilitate understanding.

Presentation file name should end with `.presentation.md`.

If the presentation already exists, first review the existing slides in order to have a clear
understanding of the current content and identify areas for improvement. Consider the
following questions:

- Are the slides visually appealing and easy to read?
- Do the slides effectively communicate the key messages?
- Are there any unnecessary or redundant slides that can be removed?
- Are there any opportunities to add visuals or examples to enhance understanding?
- Is the flow of the slides logical and easy to follow?
- Are the presenter notes clear and helpful for the presenter?

Using `askQuestions`, ask about target audience unless original file to edit mention it,
propose some options for the target audience and ask for selection. This will help tailor
the content to the specific needs of the learners.

Do not hesitate to add intermediate explanation or other theories not mentioned in this
prompt so neophites will not be lost.

## Presentation format

The document will use marpkit format <https://marpit.marp.app/usage>.

Use this [marp example](assets/marp.example.presentation.md) as a template for the slides. It contains
marp directives and formatting. It includes examples of how to use theme CSS, tweak styles
in Markdown, and apply scoped styles. You can customize the styles to fit the theme of your
presentation and make it visually appealing. Do **not** take in consideration the text
content of the example, it is only for formatting and styling reference.

You can use this template as a starting point for additional slides that can be added in the
future.

## Slides

Each slide is cut into two parts: the presenter notes and the content of the slide.

### General guidelines

Use [frontmatter](assets/marp.frontmatter.yaml) to set global options for the presentation,
such as theme, pagination, and background images.

#### Content of a slide

The content of the slides will be organized in a clear and logical manner. Each slide will
focus on a specific topic or concept, and the information will be presented in a concise
and easy-to-understand way. Use bullet points, images, and diagrams to enhance the visual
appeal and make the content more engaging.
The slide will include basic information in order to not lose the learner.

#### Footer

Use the footer to indicate:

- the page number and the total number of pages (at the bottom right of the slide)
  - use `style`, `paginate` and `_paginate` option in frontmatter as specified in
    [frontmatter](assets/marp.frontmatter.yaml)
- the current section title (at the bottom left of the slide)
  - use `footer` option in frontmatter, it can be overridden by local directive
    `footer` in the slide content if necessary

#### Diagram

If necessary, you can create plantuml and mermaid diagrams to illustrate complex concepts or
processes. These diagrams can help learners visualize information and understand relationships
between different elements. Use clear labels and a simple design to ensure that the diagrams
are easy to understand.

Create those diagrams in assets subfolder with a meaningful name and include them in the slides
using svg extension(instead of puml or mmd), use markdown image inlining syntax.
The diagram svg file will be automatically generated from the plantuml or mermaid source file
by a separated process (no need to manually convert them).

Diagram types:

- **PlantUML**: for development subjects. Prefer the use of Plantuml diagrams, sequence diagrams,
  class diagrams, etc.
- **Mermaid**: Use for flowcharts, Gantt charts, pie charts, etc
  - [Timeline diagrams](https://mermaid.js.org/syntax/timeline.html)
  - [Flowcharts](https://mermaid.js.org/syntax/flowchart.html)
  - [Gantt charts](https://mermaid.js.org/syntax/gantt.html)
  - [Pie charts](https://mermaid.js.org/syntax/pie.html)
  - [Entity Relationship diagrams](https://mermaid.js.org/syntax/erDiagram.html)
  - [Mindmaps](https://mermaid.js.org/syntax/mindmap.html)
  - [git graphs](https://mermaid.js.org/syntax/gitgraph.html)
  - [quadrant charts](https://mermaid.js.org/syntax/quadrantChart.html)
  - [Pie charts](https://mermaid.js.org/syntax/pie.html)
  - [User journey diagrams](https://mermaid.js.org/syntax/userjourney.html)
  - [Math notations](https://mermaid.js.org/config/math.html)

#### Presenter notes

The slide will be commented live with the comments you will attach to each slide.

Each slide will include Presenter Notes that provide additional context and guidance for the
presenter. These notes will help the presenter understand the key points to emphasize and how
to effectively deliver the content.

The presenter notes should not repeat the content of the slide but rather provide insights,
examples, or anecdotes that can help the presenter connect with the audience and make the
presentation more engaging.

Presenter notes should use speech style and be written in a way that is easy for the presenter
to understand and read as is.

You will indicate for each slide:

- Web sites or resources the learner can consult to have more information on the subject.
  Indicate a one line summary of the content of the website.
- If possible add some illustration images or indicate in presenter notes a search I can do
  to find those illustrations.
- The approximate duration for each slide in the presenter notes.
- Current section name.

[Example of presenter notes](assets/presenter.notes.example.md) can be used as a template
for the presenter notes of each slide.

### First slide

The first slide will include the title of the presentation, the presenter's name, the
presentation date and image illustrating the topic.
A brief presenter notes will indicate the target audience and provide an overview of the
presentation's objectives. This will set the stage for the rest of the slides and help the
audience understand what to expect.

### Second slide

The second slide will provide the outline of the presentation, including the main topics that will be
covered. This will help the audience understand the structure of the presentation and what to expect.

### Section slides

Section slides will introduce new topics or concepts. They will provide a clear transition
between different sections of the presentation and help the audience follow along.
Presenter notes for section slides will explain the importance of the new topic and how it relates to
the overall theme of the presentation.
A specific background image or design can be used for section slides to visually differentiate them
from content slides.

### Final slide

The final slide will summarize the key takeaways from the presentation and provide a call
to action for the audience. Presenter notes for the final slide will encourage the audience
to apply what they have learned and provide resources for further learning.
A specific background image or design can be used for section slides to visually differentiate them
from content slides.

## Human Interaction Protocol

- **Clarification Process**: Ask specific questions using `ask_questions` tool
- **Question Format**: One question at a time
- **Decision Points**: Use human input for option selection when multiple approaches exist
- **Iterative Refinement**: Continuously refine the prompt based on human feedback until it meets
  the desired quality
- **Anytime**: You can ask for clarification or additional information at any point in the process
  using `ask_questions` tool.
- **Skip command**: If I skip a command, you will ask me for clarification using `ask_questions`
  tool on why and correct the rest of the process accordingly
- **Feedback Loop**: After 50 iterations or whenever necessary, use `ask_questions` tool for feedback
  on the process and make adjustments as necessary
- **Final Review**: Before finalizing the improved prompt, present it to me for review and approval
  using `ask_questions` tool.
