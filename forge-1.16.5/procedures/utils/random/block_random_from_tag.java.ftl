private static Block getRandomBlock(ResourceLocation name) {
		ITag<Block> tag = BlockTags.createOptional(name);
		return tag.getAllElements().isEmpty() ? Blocks.AIR : tag.getRandomElement(new Random());
}