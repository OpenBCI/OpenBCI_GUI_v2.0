
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    W_playback.pde (ie "Playback")

    Allow user playback control from within GUI system and address #48 and #55 on Github
                       Created: Richard Waltman - August 2018
 */
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
JSONObject savePlaybackHistoryJSON;
JSONObject loadPlaybackHistoryJSON;
final String userPlaybackHistoryFile = "SavedData/Settings/UserPlaybackHistory.json";
boolean userPlaybackFileNotFound = false;

class W_playback extends Widget {

  DataProcessing dataProcessing;
  //to see all core variables/methods of the Widget class, refer to Widget.pde
  //put your custom variables here...
  Button selectPlaybackFileButton;
  //Button widgetTemplateButton;
  int padding = 10;

  private boolean visible = true;
  private boolean updating = true;

  W_playback(PApplet _parent) {
    super(_parent); //calls the parent CONSTRUCTOR method of Widget (DON'T REMOVE)
    x = x0;
    y = y0;
    w = w0;
    h = h0;

    //This is the protocol for setting up dropdowns.
    //Note that these 3 dropdowns correspond to the 3 global functions below
    //You just need to make sure the "id" (the 1st String) has the same name as the corresponding function
    //addDropdown("pbDropdown1", "Drop 1", Arrays.asList("A", "B"), 0);
    //addDropdown("pbDropdown2", "Drop 2", Arrays.asList("C", "D", "E"), 1);
    //addDropdown("pbDropdown3", "Drop 3", Arrays.asList("F", "G", "H", "I"), 3);

    selectPlaybackFileButton = new Button (x + w - 200 - padding, y - navHeight + 2, 200, navHeight - 6, "SELECT PLAYBACK FILE", fontInfo.buttonLabel_size);


    //widgetTemplateButton = new Button (x + w/2 + 50, y + h/2, 200, navHeight, "Design Your Own Widget!", 12);
    //widgetTemplateButton.setFont(p4, 14);
    //widgetTemplateButton.setURL("http://docs.openbci.com/Tutorials/15-Custom_Widgets");
  }

  public boolean isVisible() {
    return visible;
  }
  public boolean isUpdating() {
    return updating;
  }

  public void setVisible(boolean _visible) {
    visible = _visible;
  }
  public void setUpdating(boolean _updating) {
    updating = _updating;
  }

  void update() {
    super.update(); //calls the parent update() method of Widget (DON'T REMOVE)

  }

  void draw() {
    //Only draw if the widget is visible and User settings have been loaded
    //settingsLoadedCheck is set to true after default settings are saved between Init checkpoints 4 and 5
    if(visible && settingsLoadedCheck) {
      super.draw(); //calls the parent draw() method of Widget (DON'T REMOVE)

      //x,y,w,h are the positioning variables of the Widget class
      pushStyle();
      fill(boxColor);
      stroke(boxStrokeColor);
      strokeWeight(1);
      //rect(x, y, w, h);
      //Add text if needed
      /*
      fill(bgColor);
      textFont(h3, 16);
      textAlign(LEFT, TOP);
      text("PLAYBACK FILE", x + padding, y + padding);
      */
      popStyle();

      //These variables are used to show 10 of 100 latest playback files
      //fileSelectTabsInt changes when user selects playback range from dropdown
      int numFilesToShow = 10;
      int fileSelectTabsInt = 10;
      //Load the JSON array from setting
      if (!userPlaybackFileNotFound) {
        try {
          loadPlaybackHistoryJSON = loadJSONObject(userPlaybackHistoryFile);

          JSONArray loadPlaybackHistoryJSONArray = loadPlaybackHistoryJSON.getJSONArray("PlaybackFileHistory");
          //println("History Size = " + loadPlaybackHistoryJSONArray.size());
          numFilesToShow = fileSelectTabsInt + loadPlaybackHistoryJSONArray.size()%10;
          //for all files that appear in JSON array in increments of 10
          //println(fileSelectTabsInt + " " + numFilesToShow);
          for (int i = fileSelectTabsInt; i < numFilesToShow; i++) {
            JSONObject loadRecentPlaybackFile = loadPlaybackHistoryJSONArray.getJSONObject(i);
            int fileNumber = loadRecentPlaybackFile.getInt("RecentFileNumber");
            String fileName = loadRecentPlaybackFile.getString("id");
            //Set up the string that will be displayed for each recent file
            int digitPadding = 0;
            if (fileNumber == 100) {
              digitPadding = 3;
            } else if (fileNumber >= 10 && fileNumber <= 99) {
              digitPadding = 2;
            } else if (fileNumber <= 9) {
              digitPadding = 1;
            }
            String fileNumberString = nfs(fileNumber, digitPadding) + ". ";
            //Draw the text for each fileName
            fill(bgColor);
            textAlign(LEFT, TOP);
            textFont(p1, 20);
            text(fileNumberString + fileName, x + padding, y + (i%10 * padding * 2.3));
            //popStyle();
            //println(fileName);
          }
        } catch (NullPointerException e) {
          println("Playback history file not found.");
          userPlaybackFileNotFound = true;
        }
      }

      pushStyle();
      //widgetTemplateButton.draw();
      selectPlaybackFileButton.draw();
      popStyle();
    }
  } //end draw loop

  void screenResized() {
    super.screenResized(); //calls the parent screenResized() method of Widget (DON'T REMOVE)

    //put your code here...
    //resize and position the playback file box and button
    //widgetTemplateButton.setPos(x + padding, y + padding*2 + 13);
    selectPlaybackFileButton.setPos(x + w - 200 - padding, y - navHeight + 2);
  } //end screen Resized

  void mousePressed() {
    super.mousePressed(); //calls the parent mousePressed() method of Widget (DON'T REMOVE)

    if (selectPlaybackFileButton.isMouseHere()) {
      selectPlaybackFileButton.setIsActive(true);
      selectPlaybackFileButton.wasPressed = true;
    }

    //put your code here...
    /*
    if(widgetTemplateButton.isMouseHere()) {
      widgetTemplateButton.setIsActive(true);
    }
    */
  } // end mouse Pressed

  void mouseReleased() {
    super.mouseReleased(); //calls the parent mouseReleased() method of Widget (DON'T REMOVE)

    //put your code here...
    /*
    if(widgetTemplateButton.isActive && widgetTemplateButton.isMouseHere()) {
      widgetTemplateButton.goToURL();
    }
    widgetTemplateButton.setIsActive(false);
    */

    if (selectPlaybackFileButton.isMouseHere() && selectPlaybackFileButton.wasPressed) {
      //playbackData_fname = "N/A"; //reset the filename variable
      //has_processed = false; //reset has_processed variable
      output("select a file for playback");
      selectInput("Select a pre-recorded file for playback:", "playbackSelectedWidgetButton");
    }
    selectPlaybackFileButton.setIsActive(false);
  } // end mouse Released
}; //end Playback widget class

//GLOBAL FUNCTIONS BELOW THIS LINE

//These functions need to be global! These functions are activated when an item from the corresponding dropdown is selected
void pbDropdown1(int n) {
  println("Item " + (n+1) + " selected from Dropdown 1");
  if(n==0) {
    //do this
  } else if(n==1) {
    //do this instead
  }
  closeAllDropdowns(); // do this at the end of all widget-activated functions to ensure proper widget interactivity ... we want to make sure a click makes the menu close
}

void pbDropdown2(int n) {
  println("Item " + (n+1) + " selected from Dropdown 2");
  closeAllDropdowns();
}

void pbDropdown3(int n) {
  println("Item " + (n+1) + " selected from Dropdown 3");
  closeAllDropdowns();
}

void playbackSelectedWidgetButton(File selection) {
  if (selection == null) {
    println("W_Playback: playbackSelected: Window was closed or the user hit cancel.");
  } else {
    println("W_Playback: playbackSelected: User selected " + selection.getAbsolutePath());
    output("You have selected \"" + selection.getAbsolutePath() + "\" for playback.");
    playbackData_fname = selection.getAbsolutePath();

    //If a new file was selected, process it so we can set variables first.
    processNewPlaybackFile();

    //Determine the number of channels and updateToNChan()
    determineNumChanFromFile(playbackData_table);

    //Print success message
    outputSuccess("You have selected \""
    + selection.getName() + "\" for playback. "
    + str(nchan) + " channels found.");

    //Tell TS widget that the number of channel bars needs to be updated
    w_timeSeries.updateNumberOfChannelBars = true;

    //Reinitialize core data, EMG, FFT, and Headplot number of channels
    reinitializeCoreDataAndFFTBuffer();

    //Process the file again to fix issue. This makes indexes for playback slider load properly
    try {
      hasRepeated = false;
      has_processed = false;
      process_input_file();
      println("+++GUI update process file has occurred");
    }
    catch(Exception e) {
      isOldData = true;
      output("+++Error processing timestamps, are you using old data?");
    }

  }
}

void processNewPlaybackFile() { //Also used in DataLogging.pde
  //Fix issue for processing successive playback files
  indices = 0;
  hasRepeated = false;
  has_processed = false;
  if (systemMode == SYSTEMMODE_POSTINIT) {
    w_timeSeries.scrollbar.skipToStartButtonAction(); //sets scrollbar to 0
  }

  //initialize playback file
  initPlaybackFileToTable();
}

void initPlaybackFileToTable() { //also used in OpenBCI_GUI.pde on system start
  //open and load the data file
  println("OpenBCI_GUI: initSystem: loading playback data from " + playbackData_fname);
  try {
    playbackData_table = new Table_CSV(playbackData_fname);
    //removing first column of data from data file...the first column is a time index and not eeg data
    playbackData_table.removeColumn(0);
  } catch (Exception e) {
    println("OpenBCI_GUI: initSystem: could not open file for playback: " + playbackData_fname);
    println("   : quitting...");
    hub.killAndShowMsg("Could not open file for playback: " + playbackData_fname);
  }

  println("OpenBCI_GUI: initSystem: loading complete.  " + playbackData_table.getRowCount() + " rows of data, which is " + round(float(playbackData_table.getRowCount())/getSampleRateSafe()) + " seconds of EEG data");
}


void reinitializeCoreDataAndFFTBuffer() {
  //println("Data Processing Number of Channels is: " + dataProcessing.nchan);
  dataProcessing.nchan = nchan;
  dataProcessing.fs_Hz = getSampleRateSafe();
  dataProcessing.data_std_uV = new float[nchan];
  dataProcessing.polarity = new float[nchan];
  dataProcessing.newDataToSend = false;
  dataProcessing.avgPowerInBins = new float[nchan][dataProcessing.processing_band_low_Hz.length];
  dataProcessing.headWidePower = new float[dataProcessing.processing_band_low_Hz.length];
  dataProcessing.defineFilters();  //define the filters anyway just so that the code doesn't bomb

  //initialize core data objects
  nDataBackBuff = 3*(int)getSampleRateSafe();
  dataPacketBuff = new DataPacket_ADS1299[nDataBackBuff]; // call the constructor here
  nPointsPerUpdate = int(round(float(update_millis) * getSampleRateSafe()/ 1000.f));
  dataBuffX = new float[(int)(dataBuff_len_sec * getSampleRateSafe())];
  dataBuffY_uV = new float[nchan][dataBuffX.length];
  dataBuffY_filtY_uV = new float[nchan][dataBuffX.length];
  yLittleBuff = new float[nPointsPerUpdate];
  yLittleBuff_uV = new float[nchan][nPointsPerUpdate]; //small buffer used to send data to the filters
  auxBuff = new float[3][nPointsPerUpdate];
  accelerometerBuff = new float[3][500]; // 500 points
  for (int i=0; i<n_aux_ifEnabled; i++) {
    for (int j=0; j<accelerometerBuff[0].length; j++) {
      accelerometerBuff[i][j] = 0;
    }
  }
  //data_std_uV = new float[nchan];
  data_elec_imp_ohm = new float[nchan];
  is_railed = new DataStatus[nchan];
  for (int i=0; i<nchan; i++) is_railed[i] = new DataStatus(threshold_railed, threshold_railed_warn);
  for (int i=0; i<nDataBackBuff; i++) {
    dataPacketBuff[i] = new DataPacket_ADS1299(nchan, n_aux_ifEnabled);
  }
  dataProcessing = new DataProcessing(nchan, getSampleRateSafe());
  dataProcessing_user = new DataProcessing_User(nchan, getSampleRateSafe());

  //initialize the data
  prepareData(dataBuffX, dataBuffY_uV, getSampleRateSafe());

  //verbosePrint("W_Playback: initSystem: -- Init 1 -- " + millis());
  //verbosePrint("W_Playback: initSystem: Initializing FFT data objects");

  //initialize the FFT objects
  for (int Ichan=0; Ichan < nchan; Ichan++) {
    // verbosePrint("Init FFT Buff – " + Ichan);
    fftBuff[Ichan] = new FFT(getNfftSafe(), getSampleRateSafe());
  }  //make the FFT objects

  //printArray(fftBuff);

  //Attempt initialization. If error, print to console and exit function.
  //Fixes GUI crash when trying to load outdated recordings
  try {
    initializeFFTObjects(fftBuff, dataBuffY_uV, getNfftSafe(), getSampleRateSafe());
  } catch (ArrayIndexOutOfBoundsException e) {
    //e.printStackTrace();
    outputError("Playback file load error. Try using a more recent recording.");
    return;
  }

  //verbosePrint("OpenBCI_GUI: initSystem: -- Init 2 -- " + millis());

  //Update the number of channels for FFT
  w_fft.fft_points = null;
  w_fft.fft_points = new GPointsArray[nchan];
  w_fft.initializeFFTPlot(ourApplet);
  w_fft.update();

  //Update the number of channels for EMG
  w_emg.motorWidgets = null;
  w_emg.updateEMGMotorWidgets(nchan);

  //Update the number of channels for HeadPlot
  w_headPlot.headPlot = null;
  w_headPlot.updateHeadPlot(nchan);

}