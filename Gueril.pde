PImage originalImg;
PImage blurredImg;
PImage desaturatedImage;
PImage[] posterisedLayers;

int displayX, displayY;
int tempDisplayX, tempDisplayY;
float displayScale;

int dragStartX, dragStartY;

int blurValue;
int numLayers;

Button testButt;
Button saveButt;
Slider blurSlider;
Slider layersSlider;
MultibandSlider mbSlider;

boolean imageLoaded = true;

void setup() {
    blurValue = 0;
    numLayers = 1;

    displayX = 202;
    displayY = 10;
    displayScale = 1;

    size(1200, 800);
    frameRate(24);
    testButt = new Button("New Stencil", buttonType.PRIMARY, 10, 10) {
        public void action() {
            selectInput("Select an image to load:", "fileSelected");
        }
    };
    blurSlider = new Slider(10, 100, 0, 10, 172);
    layersSlider = new Slider(10, 150, 1, 10, 172);
    mbSlider = new MultibandSlider(10, 200, 172, 500, 0, 255, numLayers);

    saveButt = new Button("Save Layers", buttonType.PRIMARY, 10, 710) {
        public void action() {
            if (originalImg != null) exportLayers(posterise(desaturatedImage));
        }
    };
}

void draw() {
    background(255);
    noStroke();
    if (originalImg != null) {
        if (blurSlider.getValue() != blurValue) {
            updateBlur();
        }
        for (PImage i : posterise(desaturatedImage)) {
            image(i, displayX, displayY, originalImg.width * displayScale, originalImg.height * displayScale);
        }
    }

    if (layersSlider.getValue() != numLayers) {
        numLayers = layersSlider.getValue();
        mbSlider.setBands(numLayers);
    }

    fill(#CED4DA);
    rect(0, 0, 192, height);
    testButt.render();
    saveButt.render();
    blurSlider.render();

    layersSlider.render();

    mbSlider.render();
}

void updateBlur() {
    blurValue = blurSlider.getValue();
    blurredImg = originalImg.get();
    blurredImg.filter(BLUR, blurValue);
    desaturatedImage = desaturate(blurredImg).get();
}

void fileSelected(File selection) {
    if (selection == null) {
        println("Window was closed or the user hit cancel.");
    } else {
        originalImg = loadImage(selection.getAbsolutePath());
        blurredImg = originalImg.get();
        desaturatedImage = blurredImg.get();

    }
}

void mouseClicked() {
    testButt.click();
    saveButt.click();
}

void mousePressed() {
    if (mouseX > 202) {
        tempDisplayX = displayX;
        tempDisplayY = displayY;
        dragStartX = mouseX;
        dragStartY = mouseY;
    }
}

void mouseDragged() {
    mbSlider.slide();
    blurSlider.slide();
    layersSlider.slide();

    if (mouseX > 202) {
        displayX = mouseX - dragStartX + tempDisplayX;
        displayY = mouseY - dragStartY + tempDisplayY;
    }
}


void mouseWheel(MouseEvent event) {
    if (mouseX > 202) displayScale += event.getCount() * -0.1;
}

PImage desaturate(PImage img) {
    PImage result = createImage(img.width, img.height, ARGB);

    for (int i = 0; i < img.pixels.length; i++) {
        float r = red(img.pixels[i]);
        float g = green(img.pixels[i]);
        float b = blue(img.pixels[i]);
        float lum = 0.2126 * r + 0.7152 * g + 0.0722 * b;
        result.pixels[i] = color(lum, lum, lum, alpha(img.pixels[i]));
    }

    return result;
}

PImage[] posterise(PImage img) {
    PImage[] layers = new PImage[numLayers];
    if (img == null) return layers;

    int[] mbValues = mbSlider.getValues();
    int[] mbColors = mbSlider.getColors();

    for (int i = 0; i < numLayers; i++) {
        layers[i] = createImage(img.width, img.height, ARGB);
    }
    int[] imgPixels = img.pixels; // Store image pixels array
    for (int i = 0; i < img.pixels.length; i++) {
        int lum = (imgPixels[i] >> 16) & 0xFF;
        for (int b = 0; b < numLayers; b++) {
            if (lum < mbSlider.getValues()[b]) {
                int bandColor = mbSlider.getColors()[b];
                layers[b].pixels[i] = color(bandColor, bandColor, bandColor, (alpha(img.pixels[i]) > 0) ? 255 : 0);
                break;
            } else {
                layers[b].pixels[i] = color(0, 0, 0, 0);
            }
        }
    }

    return layers;
}

void exportLayers(PImage[] layers) {
    if (layers[0] != null) {
        for (int i = 0; i < layers.length; i++) {
            PGraphics output = createGraphics(layers[0].width, layers[0].height);
            output.beginDraw();
            output.background(0, 0); // Set the background with 0 alpha (fully transparent)
            output.image(layers[i], 0, 0); // Draw your image onto the PGraphics
            output.endDraw();
            output.save("Layer_" + i + ".png");
        }
    }
}