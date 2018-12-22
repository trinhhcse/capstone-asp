package com.caps.asp.service;

import com.caps.asp.model.firebase.NotificationModel;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Service
public class FireBaseService {

    private File getFile(String schemaPath) throws IOException {
        return new ClassPathResource(schemaPath).getFile();
    }

    public void initialize() {
        FileInputStream serviceAccount = null;
        try {
            serviceAccount = new FileInputStream(getFile("static/roommate-f93d4-firebase-adminsdk-klcf6-037f587183.json"));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        FirebaseOptions options = null;
        try {
            options = new FirebaseOptions.Builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .setDatabaseUrl("https://roommate-f93d4.firebaseio.com/")
                    .build();
        } catch (IOException e) {
            e.printStackTrace();
        }

        FirebaseApp.initializeApp(options);
    }

    public void pushNoti(NotificationModel notificationModel) {
        final FirebaseDatabase database = FirebaseDatabase.getInstance();
        DatabaseReference ref = database.getReference("notifications/users/" + notificationModel.getUser_id());
        DatabaseReference usersRef = ref.child(notificationModel.getNoti_uuid());

        Map<String, String> noti = new HashMap<>();

        noti.put("user_id", notificationModel.getUser_id());
        noti.put("date", notificationModel.getDate());
        noti.put("role_id", notificationModel.getRole_id());
        noti.put("room_id", notificationModel.getRoom_id());
        noti.put("room_name", notificationModel.getRoom_name());
        noti.put("status", notificationModel.getStatus());
        noti.put("type", notificationModel.getType());

        usersRef.setValueAsync(noti);
    }
}
