{
    "parent": "block/door_bottom_rh",
    "textures": {
        <#if data.particleTexture?has_content>"particle": "${data.particleTexture.format("%s:block/%s")}",</#if>
        "bottom": "${data.texture.format("%s:block/%s")}",
        "top": "${data.textureTop().format("%s:block/%s")}"
    }
}
