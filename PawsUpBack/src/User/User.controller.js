import { GenerateJwt } from '../Utils/Jwt.js'
import { checkPassword, encrypt } from '../Utils/Validator.js'
import User from './User.model.js'

export const testUser = (req, res)=>{
    return res.send({message: 'Conectado a User'})
}

export const register = async(req, res)=>{
    try{
        let body = req.body
        body.password = await encrypt(body.password)
        let user = new User(body)
        await user.save()
        return res.send({message: 'Usuario creado con exito', user})
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}

export const login = async(req, res)=>{
    try{
        let { email, password, username} = req.body
        let user = await User.findOne({email: email})
        
        if(!user )
            user = await User.findOne({username: username})

        if(!user || !password) return res.status(404).send({ message: 'Credenciales Invalidas' })

        if(await checkPassword(password, user.password)){
            const loggedUser = {
                uid: user._id,
                username: user.username,
                nombre: user.nombre,
                role: user.role
            }
            let token = await GenerateJwt(loggedUser)
            return res.send({ message: `Bienvenido ${user.nombre}`, loggedUser, token })
        } 
        return res.status(404).send({ message: 'Credenciales Invalidas' })
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}

export const defaultAdmin = async () => {
    try {
        const exists = await User.findOne({ nombre: 'ADMIN' })
        if (!exists){
            let data = {
                nombre: 'ADMIN',
                username: 'ADMIN',
                email: 'ADMIN@gmail.com',
                edad: '20',
                password: '123456',
                phone: '12345678',
                role: 'ADMIN'
            }
            data.password = await encrypt(data.password)
            let user = new User(data)
            await user.save()
        }
        return console.log('El admin ya se a creado')
    } catch (err) {
        console.error(err)
        return res.status(500).send({ message: 'El admin no se pudo crear' })
    }
}

export const updateUser = async (req, res) => {
    try {
        let { id } = req.params
        let data = req.body
        let user = await User.findOne({ _id: id })

        if(data.length == 0) return res.status(404).send({message: 'Sin datos ha actualizar'})

        if(!user) return res.status(400).send({message: 'Usuario no encontrado'})

        let updatedUser = await User.findOneAndUpdate(
            { _id: id },
            data,
            { new: true }
        )

        if (!updatedUser) return res.status(404).send({ message: 'Usuario no se pudo actualizar, intente nuevamente' })
        
        return res.send({ message: 'Cuenta Actualizada', updatedUser })
    } catch (err) {
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}

export const deleteUser = async (req, res) => {
    try {
        let { id } = req.params
        let { password } = req.body
        let user = await User.findOne({_id:id})

        if(!user || !password) return res.status(404).send({ message: 'Credenciales Invalidas' })
        if (await checkPassword(password, user.password)) {
            let deletedUser = await User.deleteOne({ _id: id })
            if (deletedUser.deleteCount == 0) return res.status(404).send({ message: 'Usuario no se pudo eliminar' })
            return res.send({ message: 'Cuenta eliminada con exito' })
        }

        return res.status(400).send({ message: 'Credenciales incorrectas' })
    } catch (err) {
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}