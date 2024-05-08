public class ToggleButton {
    private int bWidth;
    private int bHeight;

    private int xPos;
    private int yPos;

    private PFont bFont;

    private String messageOn;
    private String messageOff;
    private boolean toggled;

    public ToggleButton(String messageOn, String messageOff, int x, int y, int w) {
        this.messageOn = messageOn;
        this.messageOff = messageOff;

        this.xPos = x;
        this.yPos = y;

        this.bWidth = w;
        this.bHeight = 30;

        this.bFont = createFont("monofur.ttf", 24);

        this.toggled = true;
    }

    public boolean getState() {
        return this.toggled;
    }

    public void render() {
        if (mouseX > this.xPos && mouseX < this.xPos + this.bWidth && mouseY > this.yPos && mouseY < this.yPos + this.bHeight) {
            fill(color(59, 111, 201));
        } else {
            fill(color(69, 130, 236));
        }
        noStroke();
        rect(this.xPos, this.yPos, this.bWidth, this.bHeight);
        fill(255);
        textFont(this.bFont, 24);
        text(this.toggled ? messageOn : messageOff, this.xPos + (this.bWidth / 2), this.yPos + 24);
    }

    // override this
    public void action() {
        return;
    }

    public void click() {
        if (mouseX > this.xPos && mouseX < this.xPos + this.bWidth && mouseY > this.yPos && mouseY < this.yPos + this.bHeight) {
            action();
            this.toggled = !(this.toggled);
        }
    }
}