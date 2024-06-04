import { model, Schema } from 'mongoose'

const categoriaSchema = Schema({
    nombre: {
        type: String,
        required: true
    },
    descripcion: {
        type: String,
        required: true
    },
    tipo: {
        type: String,
        enum: ['SERVICIO', 'USUARIO'],
        default: 'USUARIO',
        uppercase: true
    }
})

export default model('Categoria', categoriaSchema)