import { Component } from 'solid-js'

export interface Item {
  title?: string
  text?: string
  icon?: Component
  href?: string
  color?: string
  titleOnly?: boolean
}

export interface ApiContentMenuItem {
  text: string
  href: string
  title?: string
  apiType: 'list' | 'object'
}
