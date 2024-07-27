"${registryname}_${cbi}": {
  "trigger": "minecraft:placed_block",
  "conditions": {
      "item": {
        "item": "${input$block}"
      }
  }
},