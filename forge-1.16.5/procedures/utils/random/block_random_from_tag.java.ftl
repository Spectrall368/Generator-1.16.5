private static Block getRandomBlock(ResourceLocation name) {
		ITag<Block> tag = BlockTags.getCollection().getTagByID(name);
		return tag.getAllElements().isEmpty() ? Blocks.AIR : tag.getRandomElement(new Random());
}