import mongoose, { model, Schema } from 'mongoose'

const publicacionSchema = Schema({
    autor: {
        type: mongoose.Schema.ObjectId,
        ref: 'User',
        required: true
    },
    descripcion: {
        type: String,
        required: true
    },
    imagen: {
        type: String,
        required: true
    },
    like: [{
        type: mongoose.Schema.ObjectId,
        ref: 'User'
    }],
    dislike: [{
        type: mongoose.Schema.ObjectId,
        ref: 'User'
    }]
})

export default model('Publicacion', publicacionSchema)