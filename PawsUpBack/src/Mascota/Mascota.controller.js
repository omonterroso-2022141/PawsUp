import { validar } from '../Utils/Validator.js'
import Mascota from './Mascota.model.js'

export const testMascota = (req, res)=>{
    return res.send({message: 'Conectado a Mascota'})
}

export const addMascota = async(req, res)=>{
    try{
        let data = req.body
        validar(data.imagen,'Y')
        const mascota = new Mascota({
            nombre: data.nombre,
            edad: data.edad,
            imagen: req.file.filename,
            ubicacion: data.ubicacion,
            tutor: data.tutor,
            descripcion: data.descripcion
        })
        await mascota.save()
        return res.send({message: 'Mascota guardada', mascota})
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}