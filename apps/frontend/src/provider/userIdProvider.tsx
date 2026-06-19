import {
  Accessor,
  createContext,
  createSignal,
  JSX,
  Setter,
  useContext,
} from 'solid-js'

interface UserIdContextValue {
  userId: Accessor<string>
  setUserId: Setter<string>
  clearUserId: () => void
}

const UserIdContext = createContext<UserIdContextValue>()

export function UserIdProvider(props: {
  initialUserId?: string
  children: JSX.Element
}) {
  const [userId, setUserId] = createSignal(props.initialUserId ?? '')

  const clearUserId = () => {
    setUserId('')
  }

  return (
    <UserIdContext.Provider value={{ userId, setUserId, clearUserId }}>
      {props.children}
    </UserIdContext.Provider>
  )
}

export function useUserId() {
  const context = useContext(UserIdContext)

  if (!context) {
    throw new Error('useUserId must be used within UserIdProvider')
  }

  return context
}
