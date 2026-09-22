# Lesson authoring contract
Each content/*.json is a UTF-8 JSON array. Each lesson must have:
- id: integer (1..44), slug: ascii dash-case, title: Chinese
- module: one of `Swift 基础`, `Swift 6 与并发`, `SwiftUI`, `原生工程实践`
- minutes: integer (usually 20..35)
- prerequisites: integer[]
- objective: one tangible skill, Chinese
- summary: short Chinese intro
- sections: [{title,html}] : original Chinese explanatory HTML (escaped Swift in pre/code); at least 3 substantive sections with worked examples and reasoning, not outline bullets
- exercise: {prompt,steps:string[],expected:string,solution:string} : specific executable or hands-on task, solution HTML with explanations. Reference real sample files/run command.
- quiz: {question,options:string[],answer:integer zero based,explanation:string}. Exactly two options of equal Chinese character length wherever feasible (e.g. 正确 / 错误). Avoid length clues.
- retrieval: string[] : 2 recall questions, answers may be in lesson/solution
- sources: [{title,url}] : official primary source, read/verified this turn
- lab: {label,path,command} : path relative workspace root, actually exists; command can say Xcode steps for apps
- pitfalls: string[] : concrete wrong intuitions for web frontend developer
- next: nullable integer, root may infer
Keep each lesson self-contained in content; CSS/JS supplied by root renderer. Do not write generated lessons HTML.
Root creates glossary at reference/glossary.html, swift-cheatsheet.html, concurrency-map.html, swiftui-dataflow.html, native-checklist.html.
Chinese prose; original worked examples; no unsupported latest-version claims. compiler is Swift 6.4 local, baseline language mode 6.0, swift-tools-version 6.0; macOS 14/iOS17 baseline. Sources changes >=6.2 explicitly mark. Course generation is NOT user mastery.
