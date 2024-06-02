import { Router } from 'express'
import { deleteUser, login, register, testUser, updateUser } from './User.controller.js'

const app = Router()

app.get('/testUser', testUser)
app.post('/register', register)
app.post('/login', login)
app.put('/updateUser/:id', updateUser)
app.delete('/deleteUser/:id', deleteUser)

export default app