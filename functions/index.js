const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()


exports.sendNotification = functions.firestore
  .document('messages/{groupId1}/{groupId2}/{message}')
  .onCreate((snap, context) => {
    //console.log(`${groupId1}/${groupId2}`)
    console.log('----------------start function--------------------')

    const doc = snap.data()
    console.log(doc)

    const idFrom = doc.idFrom
    const idTo = doc.idTo
    const userType = doc.userType
    const contentMessage = doc.content
    const type = doc.type == "1" ? 'photo' : 'text'
    const senderToken = doc.token


    // Get push token user to (receive)
    admin
      .firestore()
      .collection('users')
      .doc('Profile')
      .collection(userType == 'STUDENT' ? 'Developers' : 'Students')
      .doc(idTo)
      .get()
      .then(userTo => {
        console.log(`Found user to: ${userTo.data().displayName}`)
        console.log(userTo.data().pushToken)
        console.log(`user to ${idTo}, user from ${idFrom}`)
        if (senderToken == userTo.pushToken) {
          console.log(`This is when the token is same`)
        }
        else {
          // Get info user from (sent)
          admin
            .firestore()
            .collection('users')
            .doc('Profile')
            .collection(userType == 'STUDENT' ? 'Students' : 'Developers')
            .doc(idFrom)
            .get()
            .then(userFrom => {
              console.log(`Found user from: ${userFrom.data().displayName}`)
              const sendername = userFrom.data().displayName
              const senderPhoto = userFrom.data().photoUrl
              const payload = {
                notification: {
                  tag: 'chat',
                  title: sendername,
                  body: contentMessage,
                  badge: '1',
                  sound: 'default',
                  click_action: 'FLUTTER_NOTFICATION_CLICK'
                },
                "data": {
                  "messageType": type,
                  "sender": sendername,
                  "senderId": idFrom,
                  "sender_image": senderPhoto,
                  "to": idTo,
                }
              }
              // Let push to the target device
              admin
                .messaging()
                .sendToDevice(doc.data().pushToken, payload)
                .then(response => {
                  console.log('Successfully sent message:', response)
                })
                .catch(error => {
                  console.log('Error sending message:', error)
                })
            })
        }
        /* } else {
          console.log('Can not find pushToken target user')
        } */

      })
    return null
  })

exports.sendRequestNotification = functions.firestore
  .document('users/Profile/Developers/{developerId}/EnrollmentRequest/{stuname}')
  .onCreate((snap) => {
    console.log('request notification')
    const documentSnapshot = snap.data()
    console.log(documentSnapshot)
    const studentname = documentSnapshot['Student Name']
    const developerId = documentSnapshot.requestedTo
    console.log(`${developerId}, ${studentname}`)
    admin.firestore().collection('users').doc('Profile').collection('Developers').doc(developerId).get().then(snapshot => {
      console.log(`developer name is ${snapshot.data().displayName}`)
      const payload = {
        notification: {
          tag: 'request',
          title: 'Request',
          body: 'You Have a new Enrollment request from ' + studentname,
          badge: '1',
          sound: 'default',
        }
      }
      console.log(snapshot.data().pushToken)
      admin
        .messaging()
        .sendToDevice(snapshot.data().pushToken, payload)
        .then(response => {
          console.log('Successfully sent message:', response)
          console.log(response.results[0].error)
        })
        .catch(error => {
          console.log('Error sending message:', error)
        })
    })
    return null
  })

exports.requestRejected = functions.firestore
  .document('users/Profile/Developers/{developerId}/EnrollmentRequest/{stuname}')
  .onDelete((snap) => {
    console.log('request notification')
    const documentSnapshot = snap.data()
    console.log(documentSnapshot)
    const studentname = documentSnapshot['Student Name']
    const studentEmail = documentSnapshot['Student Email']
    const developerId = documentSnapshot.requestedTo
    console.log(`${developerId}, ${studentname}`)
    admin
      .firestore()
      .collection('users')
      .doc('Enrolled')
      .collection(developerId)
      .doc(studentname)
      .get()
      .then((snap) => {
        if (!snap.exists) {
          admin.firestore().collection('users').doc('Profile').collection('Students').doc(studentEmail).get().then(snapshot => {
            console.log(`Student name is ${snapshot.data().displayName}`)
            const payload = {
              notification: {
                tag: 'request',

                title: 'Request',
                body: 'Your request to ' + developerId + ' was rejected',
                badge: '1',
                sound: 'default',
              }
            }
            admin
              .messaging()
              .sendToDevice(snapshot.data().pushToken, payload)
              .then(response => {
                console.log('Successfully sent message:', response)
              })
              .catch(error => {
                console.log('Error sending message:', error)
              })
          })
        }
      })
    return null
  })

exports.requestAccepted = functions.firestore
  .document('users/Enrolled/{developerId}/{stuname}')
  .onCreate((snap, context) => {
    console.log('request notification')
    const documentSnapshot = snap.data()
    console.log(documentSnapshot)
    const studentname = documentSnapshot.displayName
    const studentEmail = documentSnapshot.email
    console.log(` ${studentname}`)
    admin.firestore().collection('users').doc('Profile').collection('Students').doc(studentEmail).get().then(snapshot => {
      console.log(`developer name is ${snapshot.data().displayName}`)
      const payload = {
        notification: {
          tag: 'request',

          title: 'Request',
          body: 'Your request to ' + snapshot.data().enrolledWith + ' was accepted',
          badge: '1',
          sound: 'default',
        }
      }
      admin
        .messaging()
        .sendToDevice(snapshot.data().pushToken, payload)
        .then(response => {
          console.log('Successfully sent message:', response)
        })
        .catch(error => {
          console.log('Error sending message:', error)
        })
    })
    return null
  }) 