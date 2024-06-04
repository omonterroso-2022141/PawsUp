import mongoose, { model, Schema } from 'mongoose'

const mascotaSchema = Schema({
    nombre: {
        type: String,
        required: true
    },
    edad: {
        type: String,
        required: true
    },
    imagen: {
        type: String,
        required: true
    },
    ubicacion: {
        type: String,
        required: true
    },
    tutor: {
        type: mongoose.Schema.ObjectId,
        ref: 'User',
        required: true
    },
    descripcion: {
        type: String,
        required: true
    }
})

export default model('Mascota', mascotaSchema)