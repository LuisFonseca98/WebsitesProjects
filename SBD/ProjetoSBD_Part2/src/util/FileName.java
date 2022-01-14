package util;
class FileName {
  private String fullPath;
  private char pathSeparator, extensionSeparator;

  public FileName(String str, char sep, char ext) {
    fullPath = str;
    pathSeparator = sep;
    extensionSeparator = ext;
  }

  public String extension() {
    int dot = fullPath.lastIndexOf(extensionSeparator);
    return fullPath.substring(dot + 1);
  }

  public String filename() { // gets filename without extension
    int dot = fullPath.lastIndexOf(extensionSeparator);
    int sep = fullPath.lastIndexOf(pathSeparator);
    return fullPath.substring(sep + 1, dot);
  }

  public String path() {
    int sep = fullPath.lastIndexOf(pathSeparator);
    return fullPath.substring(0, sep);
  }
  
  public String mimeType()
  { String fileExtension = extension();
      switch (fileExtension)
      {
          case "txt":
              return "text/plain";
          case "gif":
              return "image/gif";
          case "jpg":
          case "jpeg":
              return "image/jpeg";
          case "bmp":
              return "image/bmp";
          case "png":
        	  return "image/png";
          case "wav":
              return "audio/wav";
          case "mp4":
              return "video/mp4";
          case "ogv":
         	 return "video/ogg";
          case "oga":
           	 return "audio/ogg";
          case "ogx":
         	 return "application/ogg";
          case "mp3":
        	  return "audio/mpeg";
          default:
              return "application/octet-stream";
      }
  }
  
  public static void main(String[] args) {
	    final String FPATH = "WebContent\\isel.jpg";
	    FileName myHomePage = new FileName(FPATH, '\\', '.');
	    System.out.println("MimeType = " + myHomePage.mimeType());
	    System.out.println("Extension = " + myHomePage.extension());
	    System.out.println("Filename = " + myHomePage.filename());
	    System.out.println("Path = " + myHomePage.path());
	  }
}

