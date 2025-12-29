const postWrapper = async <R>(url: string, data: unknown) => {
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  if (!res.ok) {
    const text = await res.text()
    if (res.status === 401) return
    if (res.status === 403) return

    // console.log(text)
    throw new Error(`POST error ${res.status}: ${text}`)
  }
  return res.status === 204 ? undefined : ((await res.json()) as R)
}

export default postWrapper
