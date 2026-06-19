type CamelCase<S extends string> = S extends `${infer Head}_${infer Tail}`
  ? `${Head}${Capitalize<CamelCase<Tail>>}`
  : S

export type DeepCamelCase<T> = T extends readonly (infer U)[]
  ? DeepCamelCase<U>[]
  : T extends object
    ? {
        [K in keyof T as K extends string ? CamelCase<K> : K]: DeepCamelCase<
          T[K]
        >
      }
    : T
