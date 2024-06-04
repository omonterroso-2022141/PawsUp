import { hash, compare } from 'bcrypt'
import path from 'path'
import fs from 'fs'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const uploadDir = path.join(__dirname, '../public/uploads')

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

export const validar = (imagen,sevsalida) =>{
    var errors = []
    if(sevsalida === 'Y' && !imagen){
        errors.push('Selecciona una imagen en formato jpg o png')
    }else{
        if (errors.length === 0) {
            let filePath = path.join(uploadDir, imagen.filename);
            if (fs.existsSync(filePath)) {
                fs.unlinkSync(filePath);
                return ''
            }
        }
    }
    return errors
}

export const getImage = async(imagen)=>{
    const dirname = 'src/public/uploads/'
    try{
        const img = path.resolve(`${dirname}${imagen}`)
        return img
    }catch(err){
        console.error(err)
    }
}

//Validar si existe la imagen y eliminarla
export const deleteImage = (rutaImagen) => {
    // Comprueba si la imagen existe
    if (fs.existsSync(rutaImagen)) {
        //UnlinkSync elimina la imagen a travez de la ruta asincronamente
        try{
            fs.unlinkSync(rutaImagen)
            return true
        }catch(err){
            console.error(err)
            return false
        } 
    } else {
        console.log('Imagen no existe')
        return false
    }
}

/*

export const a = async(req, res)=>{
    try{
        
        return res.send({message: 'Mensaje'})
    }catch(err){
        console.error(err)
        return res.status(500).send({message: 'Error interno', err}) 
    }
}

*/