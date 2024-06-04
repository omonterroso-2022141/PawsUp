import { model, Schema } from 'mongoose'

const userSchema = Schema({
    nombre: {
        type: String,
        required: true
    },
    username: {
        type: String,
        unique: true,
        required: true
    },
    email: {
        type: String,
        match: [/\S+@\S+\.\S+/, 'Please enter a valid email'],
        required: true
    },
    edad: {
        type: String,
        required: true
    },
    password: {
        type: String,
        minLength: [6, 'Password must contain 8 or more characters'],
        required: true
    },
    coin: {
        type: Number,
        default: 10
    },
    /*
    perfil: {
        type: String,
        required: true
    },
    */
    role: {
        type: String,
        uppercase: true,
        enum: ['CLIENT', 'ADMIN', 'SERVICE'],
        default: 'CLIENT'
    }
})

export default model('User', userSchema)