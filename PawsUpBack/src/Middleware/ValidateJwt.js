import jwt from 'jsonwebtoken'
import User from '../User/User.model'

export const ValidateJwt = async(req, res, next)=>{
    try{
        let secretKey = process.env.SECRETKEY
        let token = req.headers.autorizathion

        if(!token) return res.status(404).send({message: 'Sin autorización'})

        let { uid } = jwt.verify(token, secretKey)
        let userExist = await User.findOne({_id: uid})

        if(!userExist) return res.status(404).send({ message: 'Usuario no existe o Sin autorización' })

        req.user = userExist
        next()
    }catch(err){
        console.error(err)
        return res.status(401).send({ message: 'Token invalido o expiro' })
    }
}