CreateThread(function()
  print("^0[^5ktn_smokeys^0] ^2Successfully started.")
end)

function CheckVersion()
  local currentVersion = "^3"..GetResourceMetadata("ktn_smokeys", 'version'):gsub("%.", "^7.^3").."^7"
  PerformHttpRequest('https://raw.githubusercontent.com/iKeaton/ktn_smokeys/master/version.txt', function(err, newestVersion, headers)
      if not newestVersion then print("^1Currently unable to run a version check for ^0[^5ktn_smokeys^0] ("..currentVersion.."^7)") return end
      newestVersion = "^3"..newestVersion:sub(1, -2):gsub("%.", "^7.^3"):gsub("%\r", "").."^7"
      print(newestVersion == currentVersion and "^0[^5ktn_smokeys^0] ^2You are running the latest version.^7 ("..currentVersion..")" or "^0[^5ktn_smokeys^0] ^1You are running an outdated version^7, ^1please download the updated file from keymaster^7!")
  end)
end

CheckVersion()