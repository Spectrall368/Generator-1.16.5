if (world.isRemote() && world.getServer() != null)
		world.getServer().getPlayerList().sendMessage(new StringTextComponent(${input$text}));
