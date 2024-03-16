if (world instanceof World && !((World) world).isRemote() && ((World) world).getServer() != null)
		world.getServer().getPlayerList().sendMessage(new StringTextComponent(${input$text}));
