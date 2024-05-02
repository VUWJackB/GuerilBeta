import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.event.*;

public class SaveDialogue {
    JFileChooser fileChooser;
    FileNameExtensionFilter filter;

    public SaveDialogue() {
        fileChooser = new JFileChooser();
        filter = new FileNameExtensionFilter("PNG files (*.png)", "png");
        fileChooser.setFileFilter(filter);
    }

    public String getSavePath() {
        int returnVal = fileChooser.showSaveDialog(null);
        if (returnVal == JFileChooser.APPROVE_OPTION) {
            return fileChooser.getSelectedFile().getAbsolutePath();
        }
        return null;
    }
}