import mongoose, { model, Schema } from 'mongoose'

const comentarioSchema = Schema({
    autor: {
        type: mongoose.Schema.ObjectId,
        ref: 'User',
        required: true
    },
    descripcion: {
        type: String,
        required: true
    },
    publicacion: {
        type: mongoose.Schema.ObjectId,
        ref: 'Publicacion',
        required: true
    },
    like: [{
        type: mongoose.Schema.ObjectId,
        ref: 'User',
        required: true
    }],
    dislike: [{
        type: mongoose.Schema.ObjectId,
        ref: 'User',
        required: true
    }]
})

export default model('Comentario', comentarioSchema)