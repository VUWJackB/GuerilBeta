// Button object
public class Button {
    private int bWidth;
    private int bHeight;
    private buttonType bType;

    private int xPos;
    private int yPos;

    private PFont bFont;

    private String message;

    public Button(String text, buttonType type, int x, int y) {
        textSize(24);
        textAlign(CENTER);

        this.bHeight = 30;
        this.bWidth = (text.length() * 12) + 40;

        this.bType = type;

        this.xPos = x;
        this.yPos = y;

        this.message = text;
    }

    // litera theme
    public void render() {
        if (mouseX > this.xPos && mouseX < this.xPos + this.bWidth && mouseY > this.yPos && mouseY < this.yPos + this.bHeight) {
             switch (this.bType) {
                case PRIMARY:
                    fill(color(59, 111, 201));
                    break;

                case SECONDARY:
                    fill(color(147, 154, 161));
                    break;

                case SUCCESS:
                    fill(color(2, 156, 99));
                    break;

                case INFO:
                    fill(color(20, 138, 156));
                    break;

                case WARNING:
                    fill(color(204, 147, 66));
                    break;

                case DANGER:
                    fill(color(184, 71, 67));
                    break;

                case LIGHT:
                    fill(color(211, 212, 213));
                    break;

                case DARK:
                    fill(color(82, 88, 93));
                    break;

                default:
                    fill(color(59, 111, 201));
                    break;
             }
        } else {
            switch (this.bType) {
                case PRIMARY:
                    fill(color(69, 130, 236));
                    break;

                case SECONDARY:
                    fill(color(173, 181, 189));
                    break;

                case SUCCESS:
                    fill(color(2, 184, 117));
                    break;

                case INFO:
                    fill(color(23, 162, 184));
                    break;

                case WARNING:
                    fill(color(240, 173, 78));
                    break;

                case DANGER:
                    fill(color(217, 83, 79));
                    break;

                case LIGHT:
                    fill(color(248, 249, 250));
                    break;

                case DARK:
                    fill(color(52, 58, 64));
                    break;

                default:
                    fill(color(69, 130, 236));
                    break;
            }
        }
        noStroke();
        rect(this.xPos, this.yPos, this.bWidth, this.bHeight);

        fill(255);
        text(this.message, this.xPos + (this.bWidth / 2), this.yPos + 24);
    }

    // override this
    public void action() {
        return;
    }

    public void click() {
        if (mouseX > this.xPos && mouseX < this.xPos + this.bWidth && mouseY > this.yPos && mouseY < this.yPos + this.bHeight) {
            action();
        }
    }
}

public enum buttonType {
    PRIMARY,
    SECONDARY,
    SUCCESS,
    INFO,
    WARNING,
    DANGER,
    LIGHT,
    DARK
}