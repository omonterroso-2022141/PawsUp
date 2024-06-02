import jwt from 'jsonwebtoken'

export const GenerateJwt = async(payload)=>{
    try{
        const secretKey = process.env.secretKey
        return jwt.sign(payload, secretKey, {
            expiresIn: '5h',
            algorithm: 'HS256'
        })
    }catch(err){
        console.error(err)
        return err
    }
}