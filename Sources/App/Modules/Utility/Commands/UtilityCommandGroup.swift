import Vapor

struct UtilityCommandGroup: CommandGroup {
    
    let commands: [String : AnyCommand]
    let help: String
    
    var defaultCommand: AnyCommand? {
        self.commands[UtilityFileTransferCommand.name]
    }
    var databaseCommand: AnyCommand? {
        self.commands[UtilityDatabaseTransferCommand.name]
    }
    
    init() {
        self.help = "Various utility tools"
        self.commands = [UtilityFileTransferCommand.name: UtilityFileTransferCommand(), UtilityDatabaseTransferCommand.name: UtilityDatabaseTransferCommand()]
    }
}
