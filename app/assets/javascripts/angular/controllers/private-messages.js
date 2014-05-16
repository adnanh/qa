// controller for asking questions

var ctrl_module = angular.module('qa.controllers');


ctrl_module.controller('PrivateMessagesCtrl', ['$scope', '$routeParams', '$location', 'i18n', 'PrivateMessages', 'AppAlert', 'ErrorProvider',
    function ($scope, $routeParams, $location, i18n, PrivateMessagesSrv, AppAlert, ErrorProvider) {
        // include i18n reference to current scope
        $scope.i18n = i18n;

        $scope.closeAlert = function (alert) {
            AppAlert.closeAlert(alert);
        };

        $scope.displayMessageId = $routeParams.message_id;

        $scope.markAsRead = function(message)
        {
            if (message.status == 'read')
                return;

            PrivateMessagesSrv.get(message.id)
                .success(
                function()
                {
                    message.status = 'read';
                    refreshUnreadCount();
                }
            );
        };

        $scope.delete = function(message_id)
        {
            PrivateMessagesSrv.delete(message_id)
                .success(
                function()
                {
                    switch($scope.displayMessageId)
                    {
                        case "inbox":
                            fetchInbox();
                            break;
                        case "outbox":
                            fetchOutbox();
                            break;
                        default:
                            fetchMessage($scope.displayMessageId);
                            break;
                    }
                }
            );
        }

        function refreshUnreadCount() {
            var unread = 0;

            for (var i = 0; i < $scope.inbox.length; i++)
            {
                if ($scope.inbox[i].status == 'unread')
                {
                    unread++;
                }
            }

            $scope.inboxUnreadCount = unread;
        }

        function fetchInbox() {
            PrivateMessagesSrv.inbox()
                .success(
                function(data){
                    if (data.success){
                        $scope.inbox = data.inbox;

                        refreshUnreadCount();
                    }
                    else {
                        AppAlert.add("danger", data.message);
                    }
                }
            );
        }

        function fetchOutbox() {
            PrivateMessagesSrv.outbox()
                .success(
                function(data){
                    if (data.success){
                        $scope.outbox = data.outbox;
                    }
                    else {
                        AppAlert.add("danger", data.message);
                    }
                }
            );
        }

        function fetchMessage(message_id) {

        }

        function resetNewMessage()
        {
            $scope.newMessage = {
                recipient: {
                    nickname: "",
                    selectedNickname: "",
                    id: -1
                },
                title: "",
                content: ""
            };
        }

        $scope.suggestUsers = function(filter_string) {
            return PrivateMessagesSrv.suggestUsers(filter_string).then(function(res){
                var users = [];

                if (res.data.success)
                {
                    users = res.data.users;
                }

                return users;
            });
        };

        $scope.onRecipientSelected = function(item, model, label) {
            $scope.newMessage.recipient = item;
            $scope.newMessage.recipient.selectedNickname = item.nickname;
        };

        $scope.reply = function(id, username, title) {
            $scope.displayMessageId = "new";

            resetNewMessage();

            $scope.newMessage.recipient.id = id;
            $scope.newMessage.recipient.nickname = username;
            $scope.newMessage.recipient.selectedNickname = username;
            $scope.newMessage.title = "Re: " + title;

        };

        $scope.sendMessage = function() {
            var error = "";

            if (($scope.newMessage.recipient.nickname != $scope.newMessage.recipient.selectedNickname) || ($scope.newMessage.recipient.nickname == "") || ($scope.newMessage.recipient.id == -1))
            {
                error += "Invalid recipient.\n";
            }

            if ($scope.newMessage.title == "")
            {
                error += "Message title cannot be empty.\n";
            }

            if ($scope.newMessage.content == "")
            {
                error += "Message cannot be empty.\n\n";
            }

            if (error != "")
            {
                console.log(error, $scope.newMessage);

                AppAlert.add("danger", "Following error(s) occurred:" + error);
            }
            else
            {
                PrivateMessagesSrv.send($scope.newMessage)
                    .success(
                    function(data){
                        if (data.success){
                            $location.path('/pm/outbox');
                        }
                        else {
                            AppAlert.add("danger", data.message);
                        }
                    }
                );
            }
        }

        switch($scope.displayMessageId)
        {
            case "inbox":
                fetchInbox();
                break;
            case "outbox":
                fetchInbox();
                fetchOutbox();
                break;
            case "new":
                fetchInbox();
                resetNewMessage();
                break;
            default:
                $location.path('/pm/inbox');
                break;
        }
    }
]);