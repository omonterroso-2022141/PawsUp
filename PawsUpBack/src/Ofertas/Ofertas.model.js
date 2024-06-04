import { model, Schema } from 'mongoose'

const ofertaSchema = Schema({
    nombre: {
        type: String,
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
    existencia:{
        type: Number,
        required: true
    },
    precio: {
        type: Number,
        required: true
    }
})

export default model('Oferta', ofertaSchema)