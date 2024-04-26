public class MultibandSlider {
    private int min;
    private int max;

    private int xPos;
    private int yPos;
    private int sWidth;
    private int sHeight;

    private int[] bandPos;
    private int[] bandColor;

    public MultibandSlider(int x, int y, int sliderWidth, int sliderHeight, int minValue, int maxValue, int bandNum) {
        this.xPos = x;
        this.yPos = y;
        
        this.sWidth = sliderWidth;
        this.sHeight = sliderHeight;
        
        this.min = minValue;
        this.max = maxValue;

        setBands(bandNum);
    }

    public int[] getValues() {
        int[] output = new int[this.bandPos.length];
        for (int i = 0; i < this.bandPos.length; i++) {
            output[i] = (int) map(this.bandPos[i], 0, this.sHeight - 10, this.min, this.max);
        }
        return output;
    }

    public int[] getColors() {
        return this.bandColor;
    }

    public void setBands(int bandNum) {
        this.bandPos = new int[bandNum];
        this.bandColor = new int[bandNum];
        for (int i = 0; i < bandNum - 1; i++) {
            this.bandPos[i] = (int) ((this.sHeight / bandNum) * (i + 1));
        }
        this.bandPos[bandNum - 1] = this.sHeight;

        for (int i = 0; i < bandNum; i++) {
            this.bandColor[i] = (int) ((255 / bandNum) * (i));
        }
    }

    public void slide() {
        if (mouseX > this.xPos && mouseX < this.xPos + this.sWidth) {
            for (int i = 0; i < this.bandPos.length - 1; i++) {
                if (i != 0) {
                    if (mouseY > this.yPos + this.bandPos[i - 1] && mouseY < this.yPos + this.bandPos[i]) {
                        bandPos[i] = constrain(mouseY - this.yPos + 10, this.bandPos[i - 1], this.bandPos[i + 1] -10);
                    }
                } else {
                    if (mouseY > this.yPos && mouseY < this.yPos + this.bandPos[i]) {
                        bandPos[i] = constrain(mouseY - this.yPos + 10, 10, this.bandPos[i + 1] -10);
                    }
                }
            }
        }
    }

    public void render() {
        for (int i = this.bandPos.length - 1; i >= 0; i--) {
            fill(color(bandColor[i]));
            rect(this.xPos, this.yPos, this.sWidth, this.bandPos[i]);
        }
    }
}