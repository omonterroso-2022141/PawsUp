import { model, Schema } from 'mongoose'

const userSchema = Schema({
    nombre: {
        type: String,
        required: true
    },
    username: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true
    },
    edad: {
        type: String,
        required: true
    },
    passwor: {
        type: String,
        required: true
    },
    coin: {
        type: Number,
        default: 10
    }
})

export default model('User', userSchema)