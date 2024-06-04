import { Router } from 'express'
import { subirImagen } from '../Middleware/Storage.js'
import { 
    addOferta, 
    deleteOferta, 
    getImageOferta, 
    testOferta, 
    updateOferta
} from './Ofertas.controller.js'

const app = Router()

app.get('/testOferta', testOferta)
app.post('/addOferta', subirImagen.single('imagen'), addOferta)
app.get('/getImageOferta/:imagen', getImageOferta)
app.put('/updateOferta/:id', subirImagen.single('imagen'), updateOferta)
app.delete('/deleteOferta/:id', deleteOferta)

export default app