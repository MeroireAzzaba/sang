const express = require('express')
const cors = require('cors')


const CentreRouter = require('./routes/center')

const app = express()
app.use(cors())
app.use(express.json());


app.use('/center',CentreRouter.router)


app.listen(3000,()=>console.log('server run on port 3000'))