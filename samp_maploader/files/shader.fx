texture theTex;

technique TexReplace
{
    pass P0
    {
        Texture[0] = theTex;
    }
}