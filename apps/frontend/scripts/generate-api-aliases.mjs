import fs from 'node:fs'
import path from 'node:path'
import ts from 'typescript'

const root = process.cwd()
const input = path.join(root, 'src/schema/apiTypes.ts')
const outputDir = path.join(root, 'src/schema/api')

const source = fs.readFileSync(input, 'utf8')
const ast = ts.createSourceFile(input, source, ts.ScriptTarget.Latest, true)

const commonSchemas = new Set(['Error'])

const schemaAlias = (name) => (name === 'Error' ? 'ApiError' : name)

const pascal = (value) =>
  value
    .replace(/^\((.*)\)$/, '$1')
    .replace(/[-_\s]+(.)?/g, (_, char) => (char ? char.toUpperCase() : ''))
    .replace(/^./, (char) => char.toUpperCase())

const camel = (value) =>
  pascal(value).replace(/^./, (char) => char.toLowerCase())

const plural = (value) => {
  if (value.endsWith('s')) return value
  if (value.endsWith('y')) return `${value.slice(0, -1)}ies`

  return `${value}s`
}

const propName = (name) => {
  if (ts.isIdentifier(name)) return name.text
  if (ts.isStringLiteral(name) || ts.isNumericLiteral(name)) return name.text

  return undefined
}

const getInterface = (name) =>
  ast.statements.find(
    (node) => ts.isInterfaceDeclaration(node) && node.name.text === name,
  )

const findProp = (members, name) =>
  members.find(
    (member) =>
      ts.isPropertySignature(member) &&
      member.name &&
      propName(member.name) === name,
  )

const hasObjectProp = (typeNode, name) => {
  if (!typeNode || !ts.isTypeLiteralNode(typeNode)) return false

  const prop = findProp(typeNode.members, name)

  return Boolean(prop?.type && prop.type.kind !== ts.SyntaxKind.NeverKeyword)
}

const schemaFile = (name) => {
  if (commonSchemas.has(name)) return 'common'

  const base = name
    .replace(/^(Create|Update|Delete|List|Get)/, '')
    .replace(
      /(Request|Response|Input|Output|WithStatus|WithMemberShips|WithMembers|Detail|Summary)$/,
      '',
    )

  return plural(camel(base))
}

const operationFile = (id) => {
  const normalized = id.replace(/^\((.*)\)$/, '$1')
  const match = normalized.match(/^(list|get|create|update|delete)(.+)$/)

  return match ? plural(camel(match[2])) : 'misc'
}

const add = (files, file, kind, text) => {
  files.set(file, [...(files.get(file) ?? []), { kind, text }])
}

const files = new Map()

const components = getInterface('components')
const schemas = components && findProp(components.members, 'schemas')

if (schemas?.type && ts.isTypeLiteralNode(schemas.type)) {
  for (const member of schemas.type.members) {
    if (!ts.isPropertySignature(member) || !member.name) continue

    const name = propName(member.name)
    if (!name) continue

    add(
      files,
      schemaFile(name),
      'schema',
      `export type ${schemaAlias(name)} = components['schemas']['${name}']`,
    )
  }
}

const operations = getInterface('operations')

if (operations) {
  for (const member of operations.members) {
    if (!ts.isPropertySignature(member) || !member.name) continue
    if (!member.type || !ts.isTypeLiteralNode(member.type)) continue

    const id = propName(member.name)
    if (!id) continue

    const file = operationFile(id)
    const name = pascal(id)
    const parameters = findProp(member.type.members, 'parameters')

    if (!parameters?.type || !ts.isTypeLiteralNode(parameters.type)) continue

    if (hasObjectProp(parameters.type, 'path')) {
      add(
        files,
        file,
        'operation',
        `export type ${name}PathParams = operations['${id}']['parameters']['path']`,
      )
    }

    if (hasObjectProp(parameters.type, 'query')) {
      add(
        files,
        file,
        'operation',
        `export type ${name}QueryParams = operations['${id}']['parameters']['query']`,
      )
    }
  }
}

fs.mkdirSync(outputDir, { recursive: true })

const indexPath = path.join(outputDir, 'index.ts')
if (fs.existsSync(indexPath)) fs.rmSync(indexPath)

for (const [file, entries] of [...files.entries()].sort()) {
  const imports = []

  if (entries.some((entry) => entry.kind === 'schema')) {
    imports.push("import type { components } from '~/schema/apiTypes'")
  }

  if (entries.some((entry) => entry.kind === 'operation')) {
    imports.push("import type { operations } from '~/schema/apiTypes'")
  }

  const content = [...imports, '', ...entries.map((entry) => entry.text)]
    .join('\n\n')
    .trim()

  fs.writeFileSync(path.join(outputDir, `${file}.ts`), `${content}\n`)
  console.log(`generated: src/schema/api/${file}.ts`)
}
