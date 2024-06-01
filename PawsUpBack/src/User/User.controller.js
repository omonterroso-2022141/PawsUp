import User from './User.model.js'

export const testUser = (req, res)=>{
    return res.send({message: 'Connected to User'})
}

export const register = async(req, res)=>{
    try{
        let body = req.body
        let user = new User(body)
        await user.save()
        return res.send({message: 'Usuario creado con exito', user})
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}
