import express from 'express'
import cors from 'cors'
import morgan from 'morgan'
import helmet from 'helmet'
import { config } from 'dotenv'
import routerUser from '../src/User/User.routes.js'
import routerCategoria from '../src/CategoriaPublicacion/Categoria.routes.js'
import routerOferta from '../src/Ofertas/Ofertas.routes.js'
import routerMascota from '../src/Mascota/Macota.routes.js'

const app = express()
config()
const port = process.env.PORT || 3200

app.use(express.urlencoded({ extended: false }))
app.use(express.json())
app.use(cors()) 
app.use(helmet())
app.use(morgan('dev'))

app.use('/User', routerUser)
app.use('/Categoria', routerCategoria)
app.use('/Oferta', routerOferta)
app.use('/Mascota', routerMascota)

export const initServer = () => {
    app.listen(port)
    console.log(`Server HTTP running in port ${port}`)
}
