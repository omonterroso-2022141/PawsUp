import { Router } from 'express'
import { register, testUser } from './User.controller.js'

const app = Router()

app.get('/testUser', testUser)
app.post('/register', register)

export default app