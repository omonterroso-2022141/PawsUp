import { hash, compare } from 'bcrypt'

export const encrypt = (passwor)=>{
    try{
        return hash(passwor, 10)
    }catch(err){
        console.error(err)
        return err 
    }
}

export const checkPassword = async(password, hash)=>{
    try{
        return await compare(password, hash)
    }catch(err){
        console.error(err)
        return err 
    }
}


/*

export const a = async(req, res)=>{
    try{
        
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}

*/