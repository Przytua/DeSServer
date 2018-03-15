import LeafProvider
import FluentProvider
import PostgreSQLProvider

extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(LeafProvider.Provider.self)
        try addProvider(FluentProvider.Provider.self)
        try addProvider(PostgreSQLProvider.Provider.self)
    }
    
    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
        preparations.append(RequestLog.self)
        preparations.append(BloodMessage.self)
        preparations.append(WanderingGhost.self)
        preparations.append(Replay.self)
        preparations.append(WorldTendency.self)
        preparations.append(Player.self)
        preparations.append(ServerSetting.self)
        preparations.append(SOSData.self)
        
        preparations.append(DBMigration.self)
    }
}
