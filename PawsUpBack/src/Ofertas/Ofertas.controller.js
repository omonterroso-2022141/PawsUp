import Oferta from './Ofertas.model.js'
import { deleteImage, getImage, validar } from '../Utils/Validator.js'
import { subirImagen } from '../Middleware/Storage.js'

export const testOferta = (req, res)=>{
    return res.send({message: 'Conectado a Oferta'})
}

export const addOferta = async(req, res)=>{
    try{
        let data = req.body
        validar(data.imagen,'Y')
        const oferta = new Oferta({
            nombre: data.nombre,
            descripcion: data.descripcion,
            imagen: req.file.filename,
            existencia: data.existencia,
            precio: data.precio
        })
        await oferta.save()
        return res.send({message: 'Oferta guardada con exito', oferta})
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}

export const getImageOferta = async(req, res)=>{
    try{
        let { imagen } = req.params
        let imagenResponse = await getImage(imagen)
        return res.sendFile(imagenResponse)
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error al obtener la imagen'})
    }
}

export const updateOferta = async(req, res)=>{
    try{
        let { id } = req.params
        let data = req.body
        let ofertaExiste = await Oferta.findOne({_id: id})

        if(!ofertaExiste) return res.status(400).send({message: 'No se encontro la oferta'})

        if (req.file && req.file.filename) {
            let imagenBorrada = deleteImage(`./src/public/uploads/${ofertaExiste.imagen}`)
            if(!imagenBorrada) return res.status(500).send({message: 'Error interno comuniquese con su proveedor'}) 
        }

        validar(data.imagen,'Y')
        const oferta = {
            nombre: data.nombre,
            descripcion: data.descripcion,
            imagen: req.file?.filename? req.file.filename : data.imagen,
            existencia: data.existencia,
            precio: data.precio
        }

        let ofertaActualizada = await Oferta.findOneAndUpdate(
            { _id: id },
            oferta,
            { new: true }
        )
        if(!ofertaActualizada) return res.status(400).send({message: 'Categoria no se pudo actualizar'})
        
        return res.send({message: 'Oferta actualizada con exito', ofertaActualizada})
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}

export const deleteOferta = async(req, res)=>{
    try{
        let { id } = req.params

        let ofertaExiste = await Oferta.findOne({_id: id})
        if(!ofertaExiste) return res.status(400).send({message: 'No se encontro la oferta'})
        
        let imagenBorrada = deleteImage(`./src/public/uploads/${ofertaExiste.imagen}`)
        if(!imagenBorrada) return res.status(500).send({message: 'Error interno comuniquese con su proveedor'}) 

        let deletedOferta = await Oferta.deleteOne({ _id: id })
        if (deletedOferta.deleteCount == 0) return res.status(404).send({ message: 'La oferta no se pudo eliminar' })
        
        return res.send({ message: 'Oferta eliminada con exito' })
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}