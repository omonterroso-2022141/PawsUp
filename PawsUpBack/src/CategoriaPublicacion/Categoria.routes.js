import { Router } from 'express'
import { 
    addCategoria,
    deleteCategoria,
    listCategoryServicio,
    listCategoryUsuario,
    testCategoria, 
    updateCategoria
} from './Categoria.controller.js'

const app = Router()

app.get('/testCategoria', testCategoria)
app.post('/addCategoria', addCategoria)
app.get('/listCategoryServicio', listCategoryServicio)
app.get('/listCategoryUsuario', listCategoryUsuario)
app.put('/updateCategoria/:id', updateCategoria)
app.delete('/deleteCategoria/:id', deleteCategoria)

export default app