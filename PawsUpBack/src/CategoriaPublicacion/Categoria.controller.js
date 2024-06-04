import Categoria from './Categoria.molde.js'

export const testCategoria = (req, res)=>{
    return res.send({message: 'Conectado a Categoria'})
}

export const addCategoria = async(req, res)=>{
    try{
        await (new Categoria(req.body)).save()
        return res.send({message: 'Categoria guardada con exito'})
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}

export const listCategoryServicio = async(req, res)=>{
    try{
        let categorys = await Categoria.findOne({tipo: 'SERVICIO'})
        return res.send({categorys})
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}

export const listCategoryUsuario = async(req, res)=>{
    try{
        let categorys = await Categoria.findOne({tipo: 'USUARIO'})
        return res.send({categorys})
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}

export const updateCategoria = async(req, res)=>{
    try{
        let { id } = req.params
        let data = req.body
        let categoriaExist = await Categoria.findOne({_id: id})
        if(!categoriaExist) return res.status(400).send({message: 'Categoria no encontrada'})

        let categoriaActualizada = await Categoria.findOneAndUpdate(
            { _id: id },
            data,
            { new: true }
        )
        if(!categoriaActualizada) return res.status(400).send({message: 'Categoria no se pudo actualizar'})

        return res.send({message: `Categoria ${categoriaExist.nombre} actualizada`})
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}

export const deleteCategoria = async(req, res)=>{
    try{
        let { id } = req.params
        let categoriaExist = await Categoria.findOne({_id: id})
        if(!categoriaExist) return res.status(400).send({message: 'Categoria no encontrada'})
        let deletedUser = await Categoria.deleteOne({ _id: id })
        if (deletedUser.deleteCount == 0) return res.status(404).send({ message: 'La categoria no se pudo eliminar' })
        return res.send({message: 'Categoria eliminada con exito'})
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}