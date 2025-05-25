const { PrismaClient } = require('@prisma/client');const express = require('express');
const router = express.Router()

const prisma = new PrismaClient()
router.route('/')
  .get(async (req, res) => {     res.send(await prisma.center.findMany())  })
  .post(async (req, res) => {    await prisma.center.create({ data:req.body })
                                res.send('center Added')
        })
  .put(async (req, res) => {   await prisma.center.update({ where : { id : req.body.id },
          data:req.body
        })
        res.send('center updated')
      })
  .delete(async (req,res)=>{ await prisma.center.delete({ where : { id : req.body.id  }
    })
    res.send('center deleted')
  })

  module.exports  = {router}